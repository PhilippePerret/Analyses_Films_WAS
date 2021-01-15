# encoding: UTF-8
# frozen_string_literal: true
begin
  require_module('pfa')
  Film.current.duration = Ajax.param(:duration)
  Film.current.build_pfa
rescue Exception => e
  Ajax.error(e)
end
