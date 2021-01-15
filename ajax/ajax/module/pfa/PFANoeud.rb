# encoding: UTF-8
# frozen_string_literal: true
class PFANoeud
class << self

end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :pfa, :data
def initialize(pfa, data)
  @pfa = pfa
  @data = data
end #/ initialize

def time ; @time ||= data['time'].to_f end

end #/PFANoeud
