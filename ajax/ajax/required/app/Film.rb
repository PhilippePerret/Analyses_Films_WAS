# encoding: UTF-8
# frozen_string_literal: true
require 'yaml'

class Film
class << self
  def current
    @current ||= begin
      folder = nil
      if File.exists?('../_FILMS_/CURRENT')
        folder = File.expand_path("../_FILMS_/#{File.read('../_FILMS_/CURRENT').strip}")
        folder = nil if not(File.exists?(folder))
      end
      folder ||= get_first_directory # peut être nil
      folder && new(folder)
    end
  end
  def get_first_directory
    Dir["../_FILMS_/*"].each do |p|
      return p if File.directory?(p)
    end
    return nil
  end #/ get_first_directory
end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :folder
attr_accessor :duration
def initialize(folder)
  @folder = File.expand_path(folder)
end

def open_in_finder
  `open -a Finder "#{folder}"`
end
def title
  @title ||= config['title_fr']||config['title']
end

def config
  YAML.load_file(config_path).merge!(film_folder: File.basename(folder))
end #/ config
def save_config(config)
  File.open(config_path,'wb'){|f| f.write(YAML.dump(config))}
end
def save_event(data)
  File.open(File.join(events_folder,"event-#{data['id']}.yml"),'wb') do |f|
    f.write(YAML.dump(data))
  end
end
def save_locator(data)
  File.open(File.join(locators_folder,"locator-#{data['id']}.yml"),'wb') do |f|
    f.write(YAML.dump(data))
  end
end

# Pour détruire un évènement
# TODO Plus tard, on le mettra de côté
def destroy_event(id)
  path = File.join(events_folder,"event-#{id}.yml")
  File.delete(path) if File.exists?(path)
end
def destroy_locator(id)
  path = File.join(locators_folder,"locator-#{id}.yml")
  File.delete(path) if File.exists?(path)
end
def get_events(filtre = nil)
  if filtre.nil?
    Dir["#{events_folder}/*.yml"].collect{|f| YAML.load_file(f) }
  else
    goods = []
    Dir["#{events_folder}/*.yml"].each do |f|
      dae = YAML.load_file(f)
      if filtre[:type]
        next if dae['type'] != filtre[:type] && dae['type'].split(':')[0] != filtre[:type]
      end
      goods << dae
    end
    return goods
  end
end
def get_locators
  Dir["#{locators_folder}/*.yml"].collect{|f| YAML.load_file(f) }
end

# ---------------------------------------------------------------------
#
#   TEMPS CALCULATIONS
#
# ---------------------------------------------------------------------

# Retourne la durée du film
# Note : soit c'est le point défini par l'event de type 'zr', soit 0
# soit c'est le point défini par l'event de type 'pf' soit la durée de la
# vidéo. NON : on produit une erreur
def duration
  @duration ||= begin
    dataZPoint = nil
    dataFPoint = nil
    get_events.each do |devent|
      if devent['type'] == 'nc:zr'
        dataZPoint = devent
      elsif devent['type'] == 'nc:pf'
        dataFPoint = devent
        break
      end
    end
    unless dataZPoint && dataFPoint
      raise "Impossible de calculer la durée du film, les points Zéro et Final ne sont pas définis les deux."
    end
    (dataFPoint['time'].to_f - dataZPoint['time'].to_f).to_i
  end
end #/ duration

# ---------------------------------------------------------------------
#
#   PATHS
#
# ---------------------------------------------------------------------

def events_folder
  @events_folder ||= mkdir(File.join(folder,'events'))
end
def locators_folder
  @locators_folder ||= mkdir(File.join(folder,'locators'))
end
def folder_products
  @folder_products ||= mkdir(File.join(folder,'products'))
end
def folder_finaux
  @folder_finaux ||= mkdir(File.join(folder,'finaux'))
end
def config_path
  @config_path ||= File.join(folder, 'config.yml')
end
end #/Film
