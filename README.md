# Aurora Detector

Detects using a 360 camera if a northern light is showing in the sky and take the actions you want: take a picture, video, notify on twitter...

Since we use a 360 camera the whole sky is analyzed just with one picture.

The Aurora Detector is only working from sunset to sunrise and in case it is not completely cloudy.

Analyzes only the part of the picture that could be considered the sky.

## Setup

### What you need

* 360 Camera. I'm using a Ricoh Theta S but can be easily adapted to the one you choose. Open Spherical Camera API from Google: https://developers.google.com/streetview/open-spherical-camera/
* A charger for the camera (can disconnect the WIFI connection) or a battery bank.
* Since the camera will be outside I recommend a cover case and maybe some heating system.
* A computer (Raspberry 3 for example) with WIFI connection and internet connection not using the same WIFI connection, for example, Ethernet

### Installation
* Install Ruby 2.4+ on the computer
* Install mini_magick gem: https://github.com/minimagick/minimagick
* Download the project from github
* Edit aurora_detector_settings.rb at your convinience

```ruby
# to get the latitude and  longitude or your location:
# https://mynasadata.larc.nasa.gov/latitudelongitude-finder/
LATITUDE = 64.126521
LONGITUDE = -21.817439

# To be able to know the weather conditions get it on
# https://openweathermap.org/appid
WEATHER_API_KEY = "xxxx"

# percentage from top of the captured image to analyze (sky)
HORIZON = 35

# under this percentage of clouds we will analyze the sky
CLOUDY_LIMIT = 70

# Shutter speed: between 5-25 seconds. 5 when auroras moving fast
SHUTTER_SPEED = 5

# ISO sensitivity: 1600
ISO = 1600
```

## Using it
1. Turn on the Ricoh Theta S camera, be sure WIFI is on.
2. Connect to the WIFI of the camera from the computer
3. Be sure you have internet connection on the computer using a network cable for example
4. In command line go to your Aurora Detector folder and run in command line:
```
ruby aurora_detector.rb
```

The logs file will be created: aurora_detector.log

In case it is later than the sunset time but earlier than the sunrise time the Aurora Detector will be analyzing the sky searching for northern lights.

The last image taken to analyze will be in files folder with the name image.jpg

In case an aurora is detected then it will be called the method 'alert' and it will be taken pictures for three minutes every 10 or 20 seconds, depending on how strong is the northern light. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marioruiz/aurora-detector


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

