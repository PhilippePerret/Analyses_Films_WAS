# encoding: UTF-8
# frozen_string_literal: true
=begin
  Module pour gérer les backups du film courant
=end
require 'fileutils'
class Film
  # = main =
  #
  # Méthode principale qui procède au backup du film courant
  def backup
    mkdir(backup_today_path)
    # Fichier configuration
    FileUtils.copy_entry(config_path, backup_config_path, false, false, true)
    # Dossier documents
    FileUtils.copy_entry(folder_documents, back_documents_folder, false, false, true)
    # Events
    backup_events
    # Locators
    backup_locators
  end #/ backup

  def backup_events
    File.delete(backup_signets_path) if File.exists?(backup_signets_path)
    @stream = File.open(backup_events_path,'a')
    Dir["#{folder_events}/*.yml"].each do |path|
      @stream << File.read(path)
    end
  ensure
    @stream.close
  end

  def backup_locators
    File.delete(backup_signets_path) if File.exists?(backup_signets_path)
    @stream = File.open(backup_signets_path,'a')
    Dir["#{locators_folder}/*.yml"].each do |path|
      @stream << File.read(path)
    end
  ensure
    @stream.close
  end

  def back_documents_folder
    @back_documents_folder ||= mkdir(File.join(backup_today_path,'documents'))
  end

  def backup_config_path
    @backup_config_path ||= File.join(backup_today_path,'config.yml')
  end

  def backup_events_path
    @backup_events_path ||= File.join(backup_today_path,'aevents.yaml')
  end

  def backup_signets_path
    @backup_signets_path ||= File.join(backup_today_path, 'locators.yaml')
  end

end #/Film
