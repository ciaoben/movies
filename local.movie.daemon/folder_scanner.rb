class FolderScanner

  def initialize path=Dir.pwd
    raise 'it takes only absolute path' if !path.match(/^\//)
    Dir.chdir(path)
  end

  # return the filename (cleaned from parts of the path)
  def scan_now
    t = Dir["./**/*"].select do |fil| fil.match(/[^\/]*\.(avi|AVI|wmv|WMV|flv|FLV|mpg|MPG|mp4|MP4|mkv|MKV)/) && !fil.match(/temp\//) end
    f = [] 
    if !t.empty?
      f = t.map do |str|
        n = str.match /\/([^\/]*)$/
        n[1] if n
      end
    end
    f
  end
end