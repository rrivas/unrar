def directories_present?(dir)
  Dir.glob("#{dir}/*").entries.any? { |x| File.directory?(x) }
end

def sort_files(dir)
  Dir.entries(dir).delete_if{ |x| File.directory?(x) || x =~ /\.nfo|\.sfv/  }.sort
end

def rar_files(dir)
  files = sort_files(dir)
  files.select{ |x| x.split('.').last == 'rar' }
end

def full_file_path(dir, file)
  "#{dir}/#{file}"
end

def unrar_file(dir, file)
  file = full_file_path(dir, file)
  archive_name = `unrar lb #{file}`

  p "Unraring #{archive_name}".strip

  `unrar x #{file}`

  if $?.success?
    `rm -rf #{dir}`
  else
    File.open('output', 'a+') { |f| f.write "#{file}\n" }
  end
end

def read_dir(dir)
  if directories_present?(dir)
    Dir.glob("#{dir}/*").each_with_object({}) { |f, h| read_dir(f) }
  else
    file_to_unrar = rar_files(dir).first
    unrar_file(dir, file_to_unrar)
  end
end

directory = ARGV[0]
read_dir directory
