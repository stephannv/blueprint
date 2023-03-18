require "./html/*"

module Blueprint::HTML
  include Blueprint::HTML::BaseElements
  include Blueprint::HTML::AttributesParser
  include Blueprint::HTML::Renderer
  include Blueprint::HTML::Utils

  @buffer = IO::Memory.new

  def to_html : String
    blueprint
    @buffer.to_s
  end

  def to_html(&block) : String
    blueprint do
      yield
    end
    @buffer.to_s
  end

  def to_html(buffer : IO::Memory) : String
    @buffer = buffer
    to_html
  end

  def to_html(buffer : IO::Memory, &block) : String
    @buffer = buffer
    to_html do
      yield
    end
  end
end
