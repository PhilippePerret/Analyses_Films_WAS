# encoding: UTF-8
# frozen_string_literal: true
class Filmodico
class << self
  def get(film_id)
    @films ||= {}
    @films[film_id] ||= begin
      request = REQUEST_GET_FILM % {id: film_id.to_s}
      cmd = "mysql -e \\\"use scenariopole_biblio;#{request};\\\""
      res = `bash -c ". /Users/philippeperret/.bash_profile; shopt -s expand_aliases\n#{cmd}" 2>&1`
      lines = res.force_encoding('utf-8').split(/\n/)
      begin
        lines.shift # pour retirer la première ligne qui contient l'alerte
        break if lines[0].match?("\t")
      end while true
      keys = lines.shift.split("\t")
      values = lines.shift.split("\t")
      h = {}
      keys.each_with_index do |key, idx|
        h.merge!(key.to_sym => values[idx])
      end
      new(h)
    end
  end #/ get
end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :data
def initialize(data)
  @data = data
  log("Data du film : #{data.inspect}")
end #/ initialize

def output(as = :text, options = nil)
  case as
  when :text then titre
  else raise "Je ne connais pas le format #{as.inspect}"
  end
end #/ output
def id; @id ||= data[:id] end
def film_id; @film_id ||= data[:film_id] end
def titre; @titre ||= data[:titre] end
def titre_fr; @titre_fr ||= data[:titre_fr] end


REQUEST_GET_FILM = 'SELECT titre, titre_fr, id, film_id FROM filmodico WHERE id = \'%{id}\' || film_id =\'%{id}\';'
end #/Filmodico
