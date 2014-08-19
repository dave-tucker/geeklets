#!/usr/bin/env ruby
require 'forecast_io'
require 'fileutils'
require 'yaml'

format = ARGV[0]
BASEDIR = '~/dev/geeklets/weather'
config = YAML.load(File.open(File.expand_path("#{BASEDIR}/config.yaml")))
ForecastIO.api_key = config['api_key']

def to_celsius(f)
    c = (f - 32) / 1.8
    return c
end

def set_icon(imgname)
  output = File.expand_path("#{BASEDIR}/#{imgname}.png")
  File.delete(File.expand_path("#{BASEDIR}/weathericon.png")) if File.exists?(File.expand_path("#{BASEDIR}/weathericon.png"))
  begin
    FileUtils.copy(output,File.expand_path("#{BASEDIR}/weathericon.png"))
  rescue
    FileUtils.copy(File.expand_path("#{BASEDIR}/unknown.png"),File.expand_path("#{BASEDIR}/weathericon.png"))
  end
end

def weather_current
  set_icon(FORECAST.currently.icon)
  printf("%.1fºC, %s",
         to_celsius(FORECAST.currently.temperature),
         FORECAST.currently.summary)
end

def weather_forecast
  printf("%s", FORECAST.minutely.summary)
end

def the_time
  time_format = '%-l:%M %p'
  Time.now.strftime(time_format).downcase
end

if format == "time"
  print the_time
  Process.exit
end

FORECAST = ForecastIO.forecast(config['lat'], config['lon'])
if format == "weather_current"
  print weather_current
  Process.exit
elsif format == "weather_forecast"
  print weather_forecast
  Process.exit
end
