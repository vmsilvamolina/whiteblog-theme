require 'fileutils'
require 'tmpdir'
require 'cgi'
require 'open3'

# Generates a 1200x630 PNG preview (og:image / twitter:image) for each post
# using headless Chrome/Chromium. Existing PNGs are never overwritten; delete
# one to regenerate it. Set WHITEBLOG_CHROME to point at a specific binary.
module Previews
  CHROME_CANDIDATES = [
    '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    '/Applications/Chromium.app/Contents/MacOS/Chromium',
    '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge',
    'google-chrome-stable',
    'google-chrome',
    'chromium',
    'chromium-browser',
    'chrome',
    'microsoft-edge'
  ].freeze

  WIDTH  = 600
  HEIGHT = 315
  SCALE  = 2

  def self.chrome_path
    return @chrome_path if defined?(@chrome_path)

    candidates = [ENV['WHITEBLOG_CHROME'], *CHROME_CANDIDATES].compact.reject(&:empty?)
    @chrome_path = candidates.lazy.map { |c| resolve_executable(c) }.find { |p| p }
  end

  def self.resolve_executable(cmd)
    return (File.executable?(cmd) ? cmd : nil) if cmd.include?(File::SEPARATOR)

    ENV.fetch('PATH', '').split(File::PATH_SEPARATOR).each do |dir|
      path = File.join(dir, cmd)
      return path if File.file?(path) && File.executable?(path)
    end
    nil
  end

  def self.build_html(title, author, site_title, css)
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <link rel="preconnect" href="https://fonts.googleapis.com">
          <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
          <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Geist:wght@400..700&family=Geist+Mono:wght@400;500&display=block">
          <style>#{css}</style>
        </head>
        <body>
          <div class="box">
            <h1 class="title"><span class="hash">#</span> #{title}</h1>
            <div class="footer">
              <span>by <span class="author">#{author}</span></span>
              <span class="site">#{site_title}</span>
            </div>
          </div>
        </body>
      </html>
    HTML
  end

  def self.render(chrome, html_path, png_path, profile_dir)
    args = [
      chrome,
      '--headless=new',
      '--disable-gpu',
      '--hide-scrollbars',
      '--no-first-run',
      '--no-default-browser-check',
      "--user-data-dir=#{profile_dir}",
      "--window-size=#{WIDTH},#{HEIGHT}",
      "--force-device-scale-factor=#{SCALE}",
      '--virtual-time-budget=5000',
      "--screenshot=#{png_path}",
      "file://#{html_path}"
    ]
    # Chrome refuses to run as root (e.g. in CI containers) without this flag
    args.insert(1, '--no-sandbox') if Process.uid.zero?

    _out, err, status = Open3.capture3(*args)
    return true if status.success? && File.exist?(png_path)

    puts "ERROR: Chrome exited with #{status.exitstatus}: #{err.lines.last(3).join.strip}"
    false
  end

  def self.process(site)
    preview_dir = File.join(site.source, 'assets', 'images', 'previews')
    posts = site.collections['posts'].docs.select do |p|
      slug = p.data['slug']
      slug && !slug.empty? && !File.exist?(File.join(preview_dir, "#{slug}.png"))
    end
    return if posts.empty?

    chrome = chrome_path
    unless chrome
      puts 'WARNING: previews skipped, Chrome/Chromium not found (set WHITEBLOG_CHROME)'
      return
    end

    css_path = File.join(site.source, 'assets', 'css', 'previews.css')
    css = File.exist?(css_path) ? File.read(css_path) : ''
    puts "WARNING: CSS file not found at #{css_path}" if css.empty?

    FileUtils.mkdir_p(preview_dir)
    site_title = CGI.escapeHTML(site.config['title'].to_s)
    site_author = site.config['author']
    default_author = site_author.is_a?(Hash) ? site_author['name'] : site_author
    default_author = 'Author' if default_author.to_s.empty?
    dest_dir = File.join(site.dest, 'assets', 'images', 'previews')

    Dir.mktmpdir('whiteblog-preview') do |tmp|
      posts.each do |p|
        slug = p.data['slug']
        puts "Creating preview for: #{slug}"

        begin
          title  = CGI.escapeHTML(p.data['title'].to_s)
          author = CGI.escapeHTML((p.data['author'] || default_author).to_s)

          html_path = File.join(tmp, "#{slug}.html")
          tmp_png   = File.join(tmp, "#{slug}.png")
          File.write(html_path, build_html(title, author, site_title, css))

          next unless render(chrome, html_path, tmp_png, File.join(tmp, 'profile'))

          final_path = File.join(preview_dir, "#{slug}.png")
          FileUtils.cp(tmp_png, final_path)

          if resolve_executable('pngquant')
            puts 'Optimizing with pngquant'
            system('pngquant', '--force', '--skip-if-larger', '--ext', '.png', final_path)
          end

          # post_write runs after files are copied, so mirror it into the build
          FileUtils.mkdir_p(dest_dir)
          FileUtils.cp(final_path, dest_dir)
        rescue => e
          puts "ERROR processing #{slug}: #{e.message}"
        end
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  Previews.process(site)
end
