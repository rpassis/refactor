class Pathname
  def is_underneath?(path)
    return self.fnmatch?(File.join(path,'**'))
  end
end