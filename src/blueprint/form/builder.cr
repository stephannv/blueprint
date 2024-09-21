require "./tags"
require "./inputs"

class Blueprint::Form::Builder(T)
  include Tags

  @scope : Symbol
  @html_options : T

  def self.new(scope = :"", **html_options) : self
    new scope, html_options
  end

  def initialize(@scope, @html_options : T)
    {% T.raise "Expected T be NamedTuple, but got #{T}." unless T <= NamedTuple %}
  end

  def blueprint(&)
    form(**@html_options) do
      yield
    end
  end
end
