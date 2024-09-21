require "../form/builder"
require "../form/inputs"

module Blueprint::HTML::Forms
  def form_builder(scope : Symbol = :"", builder : Form::Builder.class = default_form_builder, **html_options, &)
    render builder.new(scope, **html_options) do |form|
      yield form
    end
  end

  def inputs(scope : Symbol | String = :"", &)
    render Form::Inputs.new(scope) do |builder|
      yield builder
    end
  end

  def default_form_builder : Form::Builder.class
    Form::Builder
  end
end
