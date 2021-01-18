# encoding: UTF-8
# frozen_string_literal: true
`open -a Atom "#{Film.current.config_path}"`
`osascript -e "tell app \"Atom\" to activate"`
