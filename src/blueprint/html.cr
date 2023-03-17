require "./html/*"

module Blueprint::HTML
  include Blueprint::HTML::BaseTags
  include Blueprint::HTML::Utils

  @buffer = IO::Memory.new

  def call : String
    blueprint
    @buffer.to_s
  end
end
