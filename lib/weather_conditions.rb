require 'net/http'
require 'json'
require 'time'

def get_sunrise_sunset
  begin
    http = Net::HTTP.new('api.sunrise-sunset.org', 80)
    resp=http.get("/json?lat=#{LATITUDE}&lng=#{LONGITUDE}")
    results=JSON.parse(resp.body)
    sunrise = results["results"]["sunrise"]
    sunset = results["results"]["sunset"]
    @logger.info "sunrise: #{sunrise}, sunset: #{sunset}"
    return Time.parse(sunrise), Time.parse(sunset)
  rescue Exception => e
    @logger.fatal "Problem on get_sunrise_sunset"
    @logger.fatal e
    return 100
  end
end

# returns from 0 to 100 the percentage of clouds
def get_cloudy
  begin
    http = Net::HTTP.new('api.openweathermap.org', 80)
    resp=http.get("/data/2.5/weather?lat=#{LATITUDE}&lon=#{LONGITUDE}&APPID=#{WEATHER_API_KEY}")
    results=JSON.parse(resp.body)
    perc_cloudy = results["clouds"]["all"].to_i
    @logger.info "cloudy: #{perc_cloudy}"
    return perc_cloudy
  rescue Exception => e
    @logger.fatal "Problem on get_cloudy"
    @logger.fatal e
    return 100
  end
end
