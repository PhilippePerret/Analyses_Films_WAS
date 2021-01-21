# encoding: UTF-8
# frozen_string_literal: true
class Film
  # Retourne une table avec en clé la clé du personnage (telle qu'utilisée
  # dans les textes) et en valeur l'instance Personnage du personnage
  def personnages
    @personnages ||= begin
      h = {}
      (config['personnages']||{}).each do |kp, dp|
        dp = {'short_name' => dp, 'nick_name' => dp, 'full_name' => dp} if dp.is_a?(String)
        h.merge!(kp => Personnage.new(dp))
      end
      h
    end
  end #/ personnages
end

class Personnage
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :data
def initialize(data)
  @data = data
end #/ initialize

def ref ; @ref ||= full_name end

def short_name  ; @short_name ||= data['short_name'] end
def nick_name   ; @nick_name  ||= data['nick_name']  end
def full_name   ; @full_name  ||= data['full_name']  end

def age         ; @age        ||= data['age']        end


end #/class Personnage
