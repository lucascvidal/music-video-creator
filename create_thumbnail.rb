require 'rmagick'
require 'dotenv/load'

def add_centered_text(image_path, text_line1, text_line2, font_path1, font_size1, font_path2, font_size2, text_color)
  original_image = Magick::Image.read(image_path).first
  resized_image = original_image.resize_to_fill(1280, 720)
  draw = Magick::Draw.new

  line2_y = 0 + font_size1

  draw.annotate(resized_image, 0, 0, 0, 0, text_line1) do
    draw.font = font_path1
    draw.pointsize = font_size1
    draw.fill = text_color
    draw.gravity = Magick::CenterGravity
  end

  draw.annotate(resized_image, 0, 0, 0, line2_y, text_line2) do
    draw.font = font_path2
    draw.pointsize = font_size2
    draw.fill = text_color
    draw.gravity = Magick::CenterGravity
  end

  resized_image.write('tmp/thumbnail.png')
end

image_path = 'tmp/image/input.png'
text_line1 = ENV["THUMBNAIL_FIRST_LINE"].upcase
text_line2 = ENV["THUMBNAIL_SECOND_LINE"].upcase
font_path1 = 'tmp/fonts/oswald.ttf'
font_size1 = 120
font_path2 = 'tmp/fonts/lato.ttf'
font_size2 = 24
text_color = 'white'

add_centered_text(image_path, text_line1, text_line2, font_path1, font_size1, font_path2, font_size2, text_color)
