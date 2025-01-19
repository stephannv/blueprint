require "html"

require "./html/*"

require "./safe_object"
require "./safe_value"

module Blueprint::HTML
  include Blueprint::HTML::AttributesHandler
  include Blueprint::HTML::BlockRenderer
  include Blueprint::HTML::BufferAppender
  include Blueprint::HTML::ElementRegistrar
  include Blueprint::HTML::ElementRenderer
  include Blueprint::HTML::OutputHelpers
  include Blueprint::HTML::Renderer
  include Blueprint::HTML::StandardElements
  include Blueprint::HTML::SVG
  include Blueprint::HTML::ValueHelpers

  @buffer : String::Builder = String::Builder.new

  def to_s : String
    to_s(@buffer)

    @buffer.to_s
  end

  def to_s(&) : String
    to_s(@buffer) { yield self }

    @buffer.to_s
  end

  def to_s(buffer : String::Builder) : Nil
    return unless render?

    @buffer = buffer

    {% if @type.has_method?(:before_render) %}
      before_render { }
    {% end %}

    {% if @type.has_method?(:around_render) %}
      around_render { blueprint }
    {% else %}
      blueprint
    {% end %}

    {% if @type.has_method?(:after_render) %}
      after_render { }
    {% end %}
  end

  def to_s(buffer : String::Builder, &) : Nil
    return unless render?

    @buffer = buffer

    {% if @type.has_method?(:before_render) %}
      before_render { yield }
    {% end %}

    {% if @type.has_method?(:around_render) %}
      around_render do
        blueprint { __capture_content__ { yield } }
      end
    {% else %}
      blueprint { __capture_content__ { yield } }
    {% end %}

    {% if @type.has_method?(:after_render) %}
      after_render { yield }
    {% end %}
  end

  private def render? : Bool
    true
  end

  private def buffering_to(other : String::Builder, &) : Nil
    original, @buffer = @buffer, other
    yield
    @buffer = original
  end
end
