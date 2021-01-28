# encoding: UTF-8
# frozen_string_literal: true
=begin
  Script pour charger une todo list
  Fonctionne avec le module javascript module/Todo_list.js
=end
relpath = Ajax.param(:relpath)
fullpath = File.join(APP_FOLDER,relpath)
tasks = if File.exists?(fullpath)
          File.read(fullpath).force_encoding('utf-8').split("\n")
        else
          []
        end

Ajax << {tasks: tasks}
