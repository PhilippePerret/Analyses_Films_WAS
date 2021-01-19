# encoding: UTF-8
# frozen_string_literal: true

APP_PER_TYPE = {
  'pdf'   => nil,
  'html'  => "Firefox",
  'epub'  => nil,
  'mobi'  => nil
}
good_types = APP_PER_TYPE.keys

type = Ajax.param(:type)

good_types.include?(type) || raise("Le type devrait être parmi : #{good_types.join(', ')}")

path = File.join(Film.current.folder,'livres',"livre.#{type}")

File.exists?(path) || raise("Le livre '#{type}' n'a pas encore été produit. Jouer la commande 'build book #{type}'.")

application = APP_PER_TYPE[type]
cmd = ["open"]
cmd << "-a #{application}" if application
cmd << "\"#{path}\""
`#{cmd.join(' ')}`
if application
  `osascript -e "tell application \"#{application}\"; activate; activate; activate; end"`
end
