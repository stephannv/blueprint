require "../../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  register_component :component_with_block, ComponentWithBlock
  register_component :component_without_block, ComponentWithoutBlock, block: false
  register_component :component_with_optional_block, ComponentWithOptionalBlock, block: :optional

  private def blueprint
    component_with_block do
      "Component with required block"
    end

    component_without_block

    component_with_optional_block do
      "Component with optional block"
    end

    component_with_optional_block
  end
end

private class ComponentWithBlock
  include Blueprint::HTML

  private def blueprint(&)
    div id: "required-block" do
      yield
    end
  end
end

private class ComponentWithoutBlock
  include Blueprint::HTML

  private def blueprint
    h1 "Component without block"
  end
end

private class ComponentWithOptionalBlock
  include Blueprint::HTML

  private def blueprint(&)
    div id: "optional-block" do
      yield
    end
  end
end

describe "components registration" do
  it "allows component helper definition" do
    page = ExamplePage.new
    expected_html = normalize_html <<-HTML
      <div id="required-block">Component with required block</div>
    HTML

    page.to_s.should contain expected_html
  end

  it "allows component helper definition without required block" do
    page = ExamplePage.new
    expected_html = normalize_html <<-HTML
      <h1>Component without block</h1>
    HTML

    page.to_s.should contain expected_html
  end

  it "allows component helper definition with optional block" do
    page = ExamplePage.new
    expected_html = normalize_html <<-HTML
      <div id="optional-block">Component with optional block</div>
      <div id="optional-block"></div>
    HTML

    page.to_s.should contain expected_html
  end
end
