# encoding: UTF-8
# frozen_string_literal: true
begin
  AFFIXE_PATH_MANUEL = File.join(APP_FOLDER,'_dev_','Manuel','Manuel_utilisateur')
  log("AFFIXE_PATH_MANUEL: #{AFFIXE_PATH_MANUEL}")
  mode = Ajax.param(:mode)
  case mode
  when 'edit'
    `open -a Typora "#{AFFIXE_PATH_MANUEL}.md"`
  else
    `open -a Aperçu "#{AFFIXE_PATH_MANUEL}.pdf"`
  end
rescue Exception => e
  Ajax.error(e)
end
