require 'fileutils'
require 'tmpdir'
require 'cgi'
require 'imgkit'

module Previews
  def self.process(site, payload)
    preview_dir = File.join(Dir.pwd, 'assets', 'images', 'previews')
    FileUtils.mkdir_p(preview_dir) rescue puts "Error creating directory: #{preview_dir}"

    site.collections['posts'].docs.each do |p|
      slug = p.data['slug']
      next if slug.nil? || slug.empty?

      final_path = File.join(preview_dir, "#{slug}.png")
      next if File.exist?(final_path)

      puts "Creating preview for: #{slug}"

      tmp_path = File.join(Dir.tmpdir, "whiteblog-preview-#{slug}-#{Process.pid}.png")

      begin
        title  = CGI.escapeHTML(p.data['title'].to_s)
        author = CGI.escapeHTML((p.data['author'] || 'Author').to_s)

        html = <<~HTML
          <!DOCTYPE html>
          <html>
            <head>
              <meta charset="utf-8">
              <link rel="preconnect" href="https://fonts.googleapis.com">
              <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
              <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300..700&display=swap">
            </head>
            <body>
              <div class="box">
                <div class="title"><h2># #{title}</h2></div>
                <div class="footer"><h3>by #{author}</h3></div>
              </div>
            </body>
          </html>
        HTML

        kit = IMGKit.new(html, {
          zoom: 1,
          quality: 100,
          width: 600,
          height: 330,
          :'enable-local-file-access' => nil,
          :'no-stop-slow-scripts' => nil,
          :'javascript-delay' => 1500
        })

        css_path = File.join(Dir.pwd, 'assets', 'css', 'previews.css')
        if File.exist?(css_path)
          kit.stylesheets << css_path
        else
          puts "WARNING: CSS file not found at #{css_path}"
        end

        File.open(tmp_path, 'wb') { |f| f << kit.to_img(:png) }

        if File.exist?(tmp_path)
          FileUtils.cp(tmp_path, final_path)

          if system('which pngquant > /dev/null 2>&1')
            puts "Optimizing with pngquant"
            system('pngquant', '--force', '--ext', '.png', final_path)
          end
        else
          puts "ERROR: Could not create tmp file #{tmp_path}"
        end

      rescue => e
        puts "ERROR processing #{slug}: #{e.message}"
        puts e.backtrace.join("\n")
      ensure
        FileUtils.rm_f(tmp_path)
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |site, payload|
  Previews.process(site, payload)
end
