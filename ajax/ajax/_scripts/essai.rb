# encoding: UTF-8
# frozen_string_literal: true


# cmd = "mysql -e \\\"use scenariopole_biblio;SHOW TABLES;\\\" 2>&1"
# cmd = "mysql -e \\\"use scenariopole_biblio;SELECT * FROM filmodico WHERE id = 20;\\\" 2>&1"
cmd = "mysql -e \\\"use scenariopole_biblio;SELECT * FROM filmodico WHERE film_id = 'BonnieAndClyde1967';\\\" 2>&1"
res = `bash -c ". /Users/philippeperret/.bash_profile; shopt -s expand_aliases\n#{cmd}"`
lines = res.force_encoding('utf-8').split(/\n/)
lines.shift # pour retirer la première ligne qui contient l'alerte
keys = lines.shift.split("\t")
values = lines.shift.split("\t")
h = {}
keys.each_with_index do |key, idx|
  h.merge!(key.to_sym => values[idx])
end
Ajax << {retour: res, messages:lines, valeurs: h}
