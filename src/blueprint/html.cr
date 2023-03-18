require "./html/*"

module Blueprint::HTML
  include Blueprint::HTML::BaseElements
  include Blueprint::HTML::AttributesParser
  include Blueprint::HTML::Renderer
  include Blueprint::HTML::Utils

  @buffer = IO::Memory.new

  def call : String
    blueprint
    @buffer.to_s
  end

  def call(buffer : IO::Memory) : String
    @buffer = buffer
    call
  end
end
