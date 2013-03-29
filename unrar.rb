require 'pathname'

TOP_GEAR_DIR = "/home/rrivas/Downloads/complete/torrents/Top.Gear.S01-S18.HDTV.XviD-Mixed"

def directories_present?(dir)
  Dir.glob("#{dir}/*").entries.any? { |x| File.directory?(x) }
end

def read_dir dir
  if directories_present?(dir)
    p "checking #{dir}"
    Dir.glob("#{dir}/*").each_with_object({}) { |f, h| read_dir(f) if File.directory?(f)}
  else
    p "im inside #{dir}"
    #p dir
    #p Dir.entries(Pathname.new(dir).parent.to_s).delete_if{ |x| x =~ /\.sfv|\.nfo/ || x == '.' || x == '..' }.sort.first
  end
end

read_dir TOP_GEAR_DIR
