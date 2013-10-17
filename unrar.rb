def directories_present?(dir)
  Dir.glob("#{dir}/*").entries.any? { |x| File.directory?(x) }
end

def sort_files(dir)
  Dir.entries(dir).delete_if{ |x| File.directory?(x) || x =~ /\.nfo|\.sfv/  }.sort
end

def unrar_file(dir, file)
  p "Unraring #{file}"

  `unrar x #{dir}/#{file}`

  unless $?.success?
    File.open('output', 'a+') { |f| f.write "#{file}\n" }
  else
    `rm -rf #{dir}`
  end
end

def read_dir(dir)
  if directories_present?(dir)
    Dir.glob("#{dir}/*").each_with_object({}) { |f, h| read_dir(f) }
  else
    files = sort_files(dir)

    files.each do |file|
      unrar_file(dir, file)
      break
    end
  end
end

directory = ARG[0]
read_dir directory
