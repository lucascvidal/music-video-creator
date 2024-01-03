require 'rmagick'
require 'net/http'
require 'json'
require 'optparse'

def generate_dalle_image(prompt, verbose)
  api_key = ENV['OPENAI_API_KEY']
  endpoint = ENV['OPENAI_IMAGES_ENDPOINT']
  uri = URI(endpoint)

  headers = {
    'Content-Type' => 'application/json',
    'Authorization' => "Bearer #{api_key}"
  }

  request_body = {
    prompt: prompt,
    model: 'dall-e-3',
    size: '1792x1024',
    quality: 'standard',
    n: 1
  }

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  response = http.post(uri.path, request_body.to_json, headers)
  image_url = JSON.parse(response.body)['data'][0]['url']

  generated_image_path = 'tmp/image/generated_image.png'
  File.open(generated_image_path, 'wb') do |file|
    file.write Net::HTTP.get(URI(image_url))
  end

  puts("Generated DALL-E image at #{generated_image_path}") if verbose
  generated_image_path
end

def generate_prompt(video_theme, verbose)
  chatgpt_endpoint = ENV['OPENAI_CHAT_COMPLETION_URL']
  uri = URI(chatgpt_endpoint)

  headers = {
    'Content-Type' => 'application/json',
    'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}"
  }

  request_body = {
    model: 'gpt-3.5-turbo',
    messages: [
      { role: 'system', content: 'You are a helpful assistant.' },
      { role: 'user', content: "Create a prompt to be used with Dall-E for generating a thumbnail for a YouTube music video with the theme '#{video_theme}'." }
    ]
  }

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  response = http.post(uri.path, request_body.to_json, headers)
  response_json = JSON.parse(response.body)

  prompt = response_json['choices'][0]['message']['content']
  puts("Generated prompt: #{prompt}") if verbose
  prompt
end

def add_centered_text(image_path, text_line1, text_line2, font_path1, font_size1, font_path2, font_size2, text_color, verbose)
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
  puts("Added centered text to the image") if verbose
end

options = { verbose: false }
OptionParser.new do |opts|
  opts.on("-v", "--verbose", "Show extra information") do
    options[:verbose] = true
  end
end.parse!

video_theme = ENV['VIDEO_THEME'].downcase
prompt = generate_prompt(video_theme, options[:verbose])
generated_image_path = generate_dalle_image(prompt, options[:verbose])

text_line1 = ENV["THUMBNAIL_FIRST_LINE"].upcase
text_line2 = ENV["THUMBNAIL_SECOND_LINE"].upcase
font_path1 = 'tmp/fonts/oswald.ttf'
font_size1 = 120
font_path2 = 'tmp/fonts/lato.ttf'
font_size2 = 24
text_color = 'white'

add_centered_text(generated_image_path, text_line1, text_line2, font_path1, font_size1, font_path2, font_size2, text_color, options[:verbose])
puts("Thumbnail created successfully!") if options[:verbose]
