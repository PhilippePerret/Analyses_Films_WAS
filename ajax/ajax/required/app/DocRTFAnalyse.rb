# encoding: UTF-8
# frozen_string_literal: true
=begin
  Class DocRTFAnalyse
  -------------------
  Pour la production simplifiée des documents RTF
=end
require 'rrtf'

class DocRTFAnalyse
class << self

end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :filepath
def initialize(filepath)
  @filepath = filepath
end

def doc
  @doc ||= RRTF::Document.new('stylesheet' => stylesheet)
end #/ doc

def save
  File.open(filepath,'wb'){|f| f.write doc.to_rtf}
end #/ save

def paragraph(style = :regular)
  doc.paragraph(styles[style.to_s])
end
alias :par :paragraph

def styles
  @styles ||= doc.stylesheet.styles
end #/ styles

def stylesheet
  YAML.load_file(File.join(__dir__,'styles.yaml'))
end #/ stylesheet
end #/DocRTFAnalyse
