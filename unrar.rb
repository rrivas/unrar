TOP_GEAR_DIR = "/home/rrivas/Downloads/complete/torrents/Top.Gear.S01-S18.HDTV.XviD-Mixed"

def directories_present?(dir)
  Dir.glob("#{dir}/*").entries.any? { |x| File.directory?(x) }
end

def read_dir dir
  if directories_present?(dir)
    Dir.glob("#{dir}/*").each_with_object({}) { |f, h| read_dir(f) }
  else
    files = Dir.entries(dir).delete_if{ |x| File.directory?(x) || x =~ /\.nfo|\.sfv/  }.sort
    
    files.each do |file|
      p "Unraring #{file}"

      `unrar x #{dir}/#{file}`

      unless $?.success?
        File.open('output', 'a+') { |f| f.write "#{file}\n" }
      else
        `rm -rf #{dir}`
      end

      break
    end
  end
end

read_dir ARGV[0]
