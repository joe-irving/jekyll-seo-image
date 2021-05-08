require 'mini_magick'
require 'uri'

config = Hash[
  "out_path" => "/home/joe/Ruby/seo-image/test/images",
  "font" => "/home/joe/Documents/Activism/Drax/drax_parody/assets/fonts/rubik/Rubik-Bold.ttf",
  "text_color" => "#091466",
  "input" => "background",
  "logo" => "/home/joe/Ruby/seo-image/test/images/drax-pp.png"
]
image_path = "/home/joe/Ruby/seo-image/test/images/banner.jpeg"
title = "Forests can fuck themselves"

IDEAL_RATIO = 1.91
IDEAL_WIDTH = 1200

module SeoImage
  class Generator < Jekyll::Generator
    priority :low
    def generate(site)
      config = site.config["seo-image"]
      logo = File.join(site.config["source"], config['logo'])
      puts site.config["source"]
      puts config["font"]
      if not config["font"] =~ URI::regexp
        font = File.join(site.config["source"], config["text"]["font"])
      else
        font = config["font"]
      end
      site.posts.docs.each do |post|
        image_path = post[config['input']]
        if image_path and image_path != ''
          if not image_path =~ URI::regexp
            image_path = File.join(site.config["source"],image_path)
          end
          dir = File.dirname(image_path)
          ext = File.extname(image_path)
          file_name = File.basename(image_path, ext)
          ext = "jpg"
          out_name = "#{file_name}-seo.#{ext}"
          out_path = File.join(site.config["source"],config["out_path"],out_name)
          image = MiniMagick::Image.open(image_path)
          image.path
          ratio = image.width/image.height
          if ratio > IDEAL_RATIO
            puts "ratio too big"
            new_width = (image.height * IDEAL_RATIO).round
            puts "new width: #{new_width}"
            image.crop "#{new_width}x#{image.height}+#{(image.width - new_width)/2}+0"
          elsif ratio < IDEAL_RATIO
            puts "ratio too small"
            new_height = (image.width / IDEAL_RATIO).round
            puts "new height: #{new_height}"
            image.crop "#{image.width}x#{new_height}+0+#{(image.height - new_height)/2}"
          end
          # Resize to opimum OG Image size
          image.resize "#{IDEAL_WIDTH}x#{IDEAL_WIDTH/IDEAL_RATIO}"
          # Add logo
          image.combine_options do |c|
            c.gravity 'SouthEast'
            c.draw "image Over 20,20 0,0 '#{logo}'"
          end
          # Add title
          image.combine_options do |c|
            c.gravity 'north'
            c.draw "text 0,70 '#{post.data["title"]}'"
            c.pointsize 70
            c.font config["text"]["font"]
            c.fill(config["text"]["color"])
          end
          image.format ext
          image.write out_path
          # output = Jekyll::StaticFile.new(site,site.config["source"],config["out_path"],out_name)
          site.static_files << Jekyll::StaticFile.new(site,site.config["source"],config["out_path"],out_name)
          # output.write(out_path)
          post.data["image"] = File.join(config["out_path"],out_name)
        end
      end
    end
  end
end

# dir = File.dirname(image_path)
# ext = File.extname(image_path)
# file_name = File.basename(image_path, ext)
# ext = "jpg"
#
# image = MiniMagick::Image.open(image_path)
# image.path
#
# puts "old width: #{image.width}"
# ratio = image.width/image.height
# if ratio > IDEAL_RATIO
#   puts "ratio too big"
#   new_width = (image.height * IDEAL_RATIO).round
#   puts "new width: #{new_width}"
#   image.crop "#{new_width}x#{image.height}+#{(image.width - new_width)/2}+0"
# elsif ratio < IDEAL_RATIO
#   puts "ratio too small"
#   new_height = (image.width / IDEAL_RATIO).round
#   puts "new height: #{new_height}"
#   image.crop "#{image.width}x#{new_height}+0+#{(image.height - new_height)/2}"
# end
#
# # Resize to opimum OG Image size
# image.resize "#{IDEAL_WIDTH}x#{IDEAL_WIDTH/IDEAL_RATIO}"
# # Add logo
# image.combine_options do |c|
#   c.gravity 'SouthEast'
#   c.draw 'image Over 20,20 0,0 "'+config['logo']+'"'
# end
# # Add title
# image.combine_options do |c|
#   c.gravity 'north'
#   c.draw "text 0,70 '#{title}'"
#   c.pointsize 70
#   c.font config["font"]
#   c.fill(config["text_color"])
# end
#
# image.format ext
# image.write config["out_path"]+"/"+file_name+"-seo."+ext
