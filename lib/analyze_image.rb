require 'mini_magick'

def analyze_image(image_file)
  image = MiniMagick::Image.open(image_file)
  image.resize "50%"
  pixels = image.get_pixels
  horizon_y = (image.height*HORIZON/100).to_i
  aurora=0
  total=image.width*horizon_y
  horizon_y.times {|y| image.width.times {|x|
    aurora+=1 if pixels[y][x][1]>(pixels[y][x][0]+20) and pixels[y][x][1]>(pixels[y][x][2]+20)
  }}

  aurora_perc = (aurora*4*100/total).to_i
  case aurora_perc
    when 0
      aurora_index = :inexistent
    when 1
      aurora_index = :very_low
    when 2
      aurora_index = :low
    when 3
      aurora_index = :medium
    when 4..5
      aurora_index = :high
    when 6..10
      aurora_index = :very_high
    when 11..20
      aurora_index = :superb
    when 21..100
      aurora_index = :imposible
  end
  @logger.info "index: #{aurora_index}. aurora: #{aurora} of a total of #{total} (#{(aurora*100/total.to_f).round(2)}%)"
  return aurora_index
end

