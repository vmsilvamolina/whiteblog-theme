require 'fileutils'
require 'imgkit'

module Previews
  def self.process(site, payload)
    begin
      # Ensure the destination directory exists
      FileUtils.mkdir('./assets/images/previews')
    rescue
    end

    # Loop through all the posts
    site.collections['posts'].docs.each do |p|
      slug = p.data['slug']
      tmp_img = "/tmp/#{slug}.png"
      src_img = "./assets/images/previews/#{slug}.png"

      # Skip if there is already an existing image.
      # To regenerate a preview image, simply delete the image in the destination folder
      if !File.exist?(src_img)
        puts "\n  Creating preview: #{slug}.png"

        # HTML for generating a @2x image of 1200x530 image at 100 quality
        # Setting the charset is helpful when you have accents in your posts title
        kit = IMGKit.new(
          "<!DOCTYPE HTML>
          <html>
            <head>
              <meta charset='utf-8' />
            </head>
            <body>
              <div class='box'>
                <div class='title'>
                    <h2># #{p.data['title']}</h2>
                </div>
                <div class='footer'>
                    <h3>by #{p.data['author']}</h3>
                </div>
              </div>
            </body>
          </html>",
          zoom: 1,
          quality: 100,
          width: 600,
          height: 330
        )

        kit.stylesheets << './assets/css/previews.css'

        # Save the image to the previews directory
        kit.to_file(src_img)

        # Optimize to reduce the size to about a third
        `pngquant #{src_img} -o #{src_img} -f`
      end
    end
  end
end

# Add a hook that's run after html is written
Jekyll::Hooks.register :site, :post_write do |site, payload|
  Previews.process(site, payload)
end

