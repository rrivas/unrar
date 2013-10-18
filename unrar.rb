PROCESSING_DIR = "/home/rrivas/Desktop/TV_Post_Processing"
RUNNING_DIR = "#{Dir.pwd}/"

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

def move_file(file_path)
  `mv #{file_path} #{PROCESSING_DIR}`
end

def delete_directory(dir)
  `rm -rf #{dir}`
end

def unpack_file(file_path, name)
  p "Unpacking #{name}"

  `unrar x #{file_path}`
  return $?.success?
end

def unrar_file(dir, file)
  file = full_file_path(dir, file)
  archive_name = `unrar lb #{file}`.strip

  if unpack_file(file, archive_name)
    move_file(archive_name)
    delete_directory(dir)
  else
    File.open('output', 'a+') { |f| f.write "#{file}\n" }
  end
end

def read_dir(dir)
  if directories_present?(dir)
    Dir.glob("#{dir}/*").each_with_object({}) { |f, h| read_dir(f) }
  else
    file_to_unrar = rar_files(dir).first
    p "----------"
    p file_to_unrar
    p "----------"
    unrar_file(dir, file_to_unrar)
  end
end

directory = ARGV[0]
read_dir directory
