# encoding: UTF-8
# frozen_string_literal: true

def mkdir(path)
  `mkdir -p "#{path}"` unless File.exists?(path)
  return path
end #/ mkdir
