# encoding: UTF-8
# frozen_string_literal: true
class Film

  # Retourne l'instance Decor du décor d'identifiant decor_id
  # Rappel : +decor_id+ peut se composer de <dec_id>:<sous_dec_id>
  def decor(decor_id)
    decors[decor_id]
  end

  # Retourne une table des décors du film
  def decors
    @decors ||= begin
      h = {}
      (config['decors']||{}).each do |did, ddata|
        dec = Decor.new(ddata.merge!('id' => did))
        decor_name = dec.hname
        h.merge!(did => dec)
        (ddata['items']||{}).each do |sdid, sdecor_name|
          sousdec = Decor.new({'hname' => "#{decor_name} : #{sdecor_name}", 'parent' => dec, 'id' => "#{did}:#{sdid}"})
          h.merge!(sousdec.id => sousdec)
        end
      end
      h
    end
  end #/ decors

end #/Film

=begin
  Instance pour les décors
  Noter qu'il s'agit aussi bien de décor que de sous-décors. La seule
  différence est que le sous-décor ont une propriété :parent définie.
=end
class Decor
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :data
def initialize(data)
  @data = data
end

def ref ; hname end

def id      ; @id       ||= data['id']       end
def hname   ; @hname    ||= data['hname']    end
def parent  ; @parent   ||= data['parent']   end

end #/Decor
