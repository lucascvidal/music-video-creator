require 'optparse'
require 'dotenv/load'
require 'uri'
require 'net/http'
require 'json'

def preview_track(key)
  puts("Previewing track with key: #{key}, and bpm: #{ENV['BPM']}") if @options[:verbose]
  preview_track_url = URI(ENV['SOUNDFUL_PREVIEW_TRACK_URL'])
  https = Net::HTTP.new(preview_track_url.host, preview_track_url.port)
  https.use_ssl = true
  request = Net::HTTP::Post.new(preview_track_url)
  request["authorizationToken"] = ENV['AUTH_TOKEN']
  request["Content-Type"] = "application/json"
  request.body = JSON.generate({ :templateId => ENV['TEMPLATE_ID'], :bpm => ENV['BPM'], :key => key })
  response = https.request(request)
  puts("Response status: #{response.code}") if @options[:verbose]
  return JSON.parse(response.read_body)
rescue => e
  puts(e)
end

def create_track(preview_id, bpm, key, template_id, duration, is_premium, template_name, index)
  puts("Creating track with id: #{preview_id}, key: #{key}") if @options[:verbose]
  create_track_url = URI("#{ENV['SOUNDFUL_CREATE_TRACK_URL']}/#{preview_id}?mode=create")
  https = Net::HTTP.new(create_track_url.host, create_track_url.port)
  https.use_ssl = true
  request = Net::HTTP::Patch.new(create_track_url)
  request["authorizationToken"] = ENV['AUTH_TOKEN']
  request["Content-Type"] = "application/json"
  request.body = JSON.generate({
    bpm: bpm,
    duration: duration,
    key: key,
    name: "#{template_name.gsub(" ","-").downcase}_#{index}_#{Time.now.strftime("%Y-%m-%d")}",
    draft: false,
    template: {
      id: template_id,
      isPremium: is_premium
    }
    })
    
  response = https.request(request)
  puts("Response status: #{response.code}") if @options[:verbose]
  return JSON.parse(response.read_body)
rescue => e
  puts(e)
end
  
def render_track(track_id)
  puts("Rendering track with id: #{track_id}") if @options[:verbose]
  render_track_url = URI("#{ENV['SOUNDFUL_RENDER_TRACK_URL']}/#{track_id}/render")
  https = Net::HTTP.new(render_track_url.host, render_track_url.port)
  https.use_ssl = true
  request = Net::HTTP::Post.new(render_track_url)
  request["authorizationToken"] = ENV['AUTH_TOKEN']
  request["Content-Type"] = "application/json"
  request.body = JSON.generate({ type: "STANDARD" })
  response = https.request(request)
  puts("Response status: #{response.code}") if @options[:verbose]
rescue => e
  puts(e)
end
  
@options = {}

OptionParser.new do |opts|
  opts.on("-v", "--verbose", "Show extra information") do
    @options[:verbose] = true
  end
end.parse!

KEYS = [
  "f_major",
  "b_flat_major",
  "c_sharp_major",
  "g_major",
  "b_major",
  "f_sharp_major",
  "a_flat_major",
  "c_major",
  "a_major",
  "e_flat_major",
  "d_major",
  "e_major"
]

puts("Do not forget to update variables in .env before running this script.")

KEYS.sample(10).each_with_index do |key, index|
  preview_track_response = preview_track(key)
  puts("Waiting a few seconds to create track.") if @options[:verbose]
  sleep(rand(2..7))

  create_track_response = create_track(preview_track_response["id"],
    preview_track_response["bpm"],
    preview_track_response["key"],
    preview_track_response["template"]["id"],
    preview_track_response["duration"],
    preview_track_response["template"]["isPremium"],
    preview_track_response["template"]["name"],
    index)
  
  puts("Waiting a few seconds to render track.") if @options[:verbose]
  sleep(rand(2..7))

  render_track(create_track_response["id"])
  puts("Waiting a few seconds to move on to the next key.") if @options[:verbose]
  sleep(rand(2..7))
end

puts("Script ran. 10 new tracks should be available at My Library in Soundful if everything went ok.")
