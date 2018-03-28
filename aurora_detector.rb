require './aurora_detector_settings'
require './lib/analyze_image'
require './lib/take_picture'
require './lib/weather_conditions'
require './lib/alert'

require 'logger'
require 'fileutils'

@logger = Logger.new("aurora_detector.log")
@logger.info "Started"
sunrise, sunset = get_sunrise_sunset
last_check_cloudy = Time.now - 400

while true
  if sunrise<Time.now and Time.now.hour==0
    sunrise, sunset = get_sunrise_sunset
  end

  if Time.now>sunrise and Time.now<sunset
    @logger.info "sleeping until sunset: #{sunset}. #{(sunset-Time.now).to_i} secs. #{((sunset-Time.now)/60/60).round(2)} hours."
    sleep (sunset-Time.now)
  elsif Time.now>sunset then
    #check clouds every 5 minutes
    if (Time.now-last_check_cloudy)>300
      cloudy=get_cloudy
      last_check_cloudy = Time.now
    end

    if cloudy < CLOUDY_LIMIT

      picture_taken = take_picture

      if picture_taken
        aurora_index = analyze_image('./files/image.jpg')
        if aurora_index==:impossible
          file_name="image_#{Time.now().strftime("%y%m%d_%H%M%S")}.jpg"
          FileUtils.cp("./files/image.jpg", "./files/#{file_name}")
          alert("weird picture. Saved: #{file_name}")
          sleep 60
        elsif aurora_index == :inexistent
          sleep 60
        else
          alert("Northern light detected! index: #{aurora_index}")
          if aurora_index==:very_low or aurora_index==:low
            take_every = 20
          else # :medium :high :very_high :superb
            take_every = 10
          end
          (300/take_every).times {
            picture_taken = take_picture
            if picture_taken
              FileUtils.cp("./files/image.jpg", "./files/image_#{Time.now().strftime("%y%m%d_%H%M%S")}.jpg")
            end
            sleep take_every
          }
        end

      else
        sleep 60
      end

    end
  else
    sleep 60
  end


end
