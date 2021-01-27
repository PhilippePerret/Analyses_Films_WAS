# encoding: UTF-8
# frozen_string_literal: true
class Film
  def build_page_composition
    PageComposition.new(self).build
  end #/ build_page_composition
end #/Film

class PageComposition
attr_reader :film
def initialize(film)
  @film = film
end #/ initialize

# = main =
def build
  data_valid? || raise("Données invalides : #{@invalidity}")

  File.delete(composition_path) if File.exists?(composition_path)

  code = File.read(template_path).force_encoding('utf-8')
  File.open(composition_path,'wb') do |f|
    f.write(code % fconfig.get(required_data).merge(print_date:Time.now.strftime('%m %Y')))
  end

end #/ build


def required_data
  @required_data ||= AUTO_DOCUMENTS['composition.html'][:required_data]
end

def data_valid?
  lakes = []
  required_data.each do |kdata|
    fconfig.send(kdata.to_sym) || lakes << kdata
  end
  @invalidity = lakes.join(', ')
  return lakes.empty?
end #/ data_valid?

def composition_path
  @cover_path ||= File.join(film.folder_products,'composition.html')
end

private

  def template_path
    @template_path ||= File.join(APP_FOLDER,'_TEMPLATES_','composition.html')
  end

  def fconfig
    @fconfig ||= FConfig.new(film)
  end #/ fconfig

end #/class PageComposition
