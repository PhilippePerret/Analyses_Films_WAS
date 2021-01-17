# encoding: UTF-8
# frozen_string_literal: true
class Scene
class << self

end # /<< self

# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :data
attr_accessor :numero
def initialize(data)
  @data = data
end

def content
  @content ||= data['content']
end #/ content
def time
  @time ||= data['time'].to_f
end #/ time


end #/Scene
