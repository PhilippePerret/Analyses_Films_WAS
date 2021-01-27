# encoding: UTF-8
# frozen_string_literal: true
require_relative './PFANoeudAbs'

class PFANoeudRel

  TOPS = {part: 9*PFA::LINE_HEIGHT, seq:12*PFA::LINE_HEIGHT, noeud:12*PFA::LINE_HEIGHT}
  RECTIFS = {part:50, seq:0, noeud:0}
  HEIGHTS = {part:PFA::LINE_HEIGHT, seq:PFA::LINE_HEIGHT, noeud:PFA::LINE_HEIGHT}
  FONTSIZES = {part:7, seq:7, noeud:7}
  FONTWEIGHTS = { part:1, seq:1, noeud:1 }
  BORDERS     = { part:1, seq:1, noeud:1 }

class << self

end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :pfa, :data
def initialize(pfa, data)
  @pfa  = pfa
  @data = data
end #/ initialize

COLORS = {part:'black', seq:'black' , noeud:'black'}

# Retourne la commande pour dessiner le noeud relatif dans le PFA
# Suivant le type
def draw_command
  send("draw_command_#{type == :part ? 'part' : 'other'}".to_sym)
end

def draw_command_part
  <<-CMD.gsub(/\n/,' ').strip
-stroke black
-strokewidth 3
-fill black
-background white
-draw "line #{left},#{top-PFA::LINE_HEIGHT/2} #{left+1},#{bottom+4*PFA::LINE_HEIGHT} "
\\(
-background white
-stroke #{COLORS[type]}
-fill #{COLORS[type]}
-strokewidth #{FONTWEIGHTS[type]}
-pointsize #{FONTSIZES[type]}
label:"#{mark}"
-size #{surface}
-trim
-gravity #{PFANoeudAbs::GRAVITIES[type]}
-extent #{surface}
\\)
-gravity northwest
-geometry +#{left+2-RECTIFS[:part]}+#{top+2}
-composite
#{mark_horloge}
  CMD
end

def draw_command_other
  <<-CMD.gsub(/\n/,' ').strip
-strokewidth #{BORDERS[type]}
-stroke #{PFANoeudAbs::COLORS[type]}
-background white
-fill white
-draw "roundrectangle #{left},#{top} #{right},#{bottom} 10,10"
\\(
-background white
-stroke #{COLORS[type]}
-fill #{COLORS[type]}
-strokewidth #{FONTWEIGHTS[type]}
-pointsize #{FONTSIZES[type]}
label:"#{mark}"
-size #{surface}
-trim
-gravity #{PFANoeudAbs::GRAVITIES[type]}
-extent #{surface}
\\)
-gravity northwest
-geometry +#{left+2}+#{top+2}
-composite
#{mark_horloge}
  CMD
end



def mark_horloge
  return '' if data[:no_horloge]
  ihorloge = Horloge.new(horloge: horloge, top:top_horloge, left:hcenter-RECTIFS[type])
  ihorloge.magick_code
end

def top_horloge
  @top_horloge ||= begin
    bottom + (part? ? -PFA::LINE_HEIGHT/5 : 2)
  end
end

def horloge; @horloge ||= time.to_i.to_horloge end
def time ; @time ||= data['time'].to_f    end
def type ; @type ||= PFA.type_of(ntype)   end
def mark ; @mark ||= PFA.mark_of(ntype)   end
def ntype
  @ntype ||= data['type'].split(':')[1]
end

def left
  @left ||= pfa.realpx(time.to_i)
end
def right
  @right ||= left + 100 # TODO
end
def hcenter
  @hcenter ||= left + (width / 2)
end
def top
  @top ||= TOPS[type]
end #/ top
def bottom
  @bottom ||= TOPS[type] + HEIGHTS[type]
end #/ bottom
def width   ; @width  ||= (right - left)  end
def height  ; @height ||= (bottom - top)  end
def surface
  @surface ||= "#{width-4}x#{height-4}"
end #/ surface

def part?
  @is_part ||= type == :part
end

end #/PFANoeudRel
