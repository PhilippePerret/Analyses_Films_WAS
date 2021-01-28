# encoding: UTF-8
# frozen_string_literal: true
=begin
  Script pour charger une todo list
  Fonctionne avec le module javascript module/Todo_list.js
=end
relpath = Ajax.param(:relpath)
fullpath = File.join(APP_FOLDER,relpath)
tasks = Ajax.param(:tasks)

File.delete(fullpath) if File.exists?(fullpath) # TODO Un backup, plus tard
File.open(fullpath,'wb'){|f|f.write(tasks.join("\n"))}
