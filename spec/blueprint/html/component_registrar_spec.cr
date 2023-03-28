require "../../spec_helper"

private class DummyPage
  include Blueprint::HTML
  include Blueprint::HTML::ComponentRegistrar

  register_component :required_block_component, RequiredBlockComponent
  register_component :no_block_component, NoBlockComponent, block: false
  register_component :optional_block_component, OptionalBlockComponent, block: :optional

  def blueprint
    required_block_component do
      "Component with required block"
    end

    no_block_component

    optional_block_component do
      "Component with optional block"
    end

    optional_block_component
  end
end

private class RequiredBlockComponent
  include Blueprint::HTML

  def blueprint(&)
    div id: "required-block" do
      yield
    end
  end
end

private class NoBlockComponent
  include Blueprint::HTML

  def blueprint
    h1 { "Component without block" }
  end
end

private class OptionalBlockComponent
  include Blueprint::HTML

  def blueprint(&)
    div id: "optional-block" do
      yield
    end
  end
end

describe "Blueprint::HTML components registration" do
  it "allows component helper definition" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <div id="required-block">Component with required block</div>
    HTML

    page.to_html.should contain expected_html
  end

  it "allows component helper definition without required block" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <h1>Component without block</h1>
    HTML

    page.to_html.should contain expected_html
  end

  it "allows component helper definition with optional block" do
    page = DummyPage.new
    expected_html = <<-HTML.strip.gsub(/\n\s+/, "")
      <div id="optional-block">Component with optional block</div>
      <div id="optional-block"></div>
    HTML

    page.to_html.should contain expected_html
  end
end
