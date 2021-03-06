# encoding: UTF-8
# frozen_string_literal: true
=begin
  Script qui permet de ne modifier qu'une valeur dans les config
=end

key = Ajax.param(:config_key)
value = Ajax.param(:config_value)

film = Film.current
config = film.config
film.save_config(config.merge(key => value))
