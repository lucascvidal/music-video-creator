require 'json'
require 'uri'
require 'net/http'
require 'dotenv/load'
require 'fileutils'

def download_track(track_info)
  track_id = track_info['track_id']
  track_name = track_info['track_name']

  puts("Downloading track with id: #{track_id}, name: #{track_name}")

  FileUtils.mkdir_p("tmp/audio/")

  track_url = URI("https://cdn.soundful.com/sounds/users/#{ENV['USER_ID']}/tracks/#{track_id}/#{track_name}_mix.mp3")
  puts("URL: #{track_url}")

  loop do
    https = Net::HTTP.new(track_url.host, track_url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(track_url)
    response = https.request(request)

    if response.code.to_i == 200
      output_file_path = "tmp/audio/#{track_name}.mp3"

      FileUtils.mkdir_p(File.dirname(output_file_path))

      File.open(output_file_path, 'wb') do |output_file|
        output_file.write(response.body)
      end

      puts("Track downloaded to tmp/audio/#{track_name}.mp3")
      break
    else
      puts("Response status code was: #{response.code}")
      puts("Waiting for 30 seconds and retrying download...")
      sleep(30)
    end
  end
rescue => e
  puts(e)
end

track_info_file = 'tmp/track_info.json'
track_info_array = JSON.parse(File.read(track_info_file))

track_info_array.each do |track_info|
  download_track(track_info)
end
