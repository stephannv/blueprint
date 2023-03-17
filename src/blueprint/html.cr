require "./html/*"

module Blueprint::HTML
  include Blueprint::HTML::BaseElements
  include Blueprint::HTML::AttributesParser
  include Blueprint::HTML::Utils

  @buffer = IO::Memory.new

  def call : String
    blueprint
    @buffer.to_s
  end
end
