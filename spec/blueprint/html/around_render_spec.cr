require "../../spec_helper"

private class ExampleWithBlock
  include Blueprint::HTML

  private def blueprint(&)
    h1 { yield }
  end

  private def around_render(&)
    span { "Before" }
    yield
    span { "After" }
  end
end

private class ExampleWithoutBlock
  include Blueprint::HTML

  private def blueprint
    h1 { "Without block" }
  end

  private def around_render(&)
    span { "Before" }
    yield
    span { "After" }
  end
end

describe "around render" do
  context "with block" do
    it "allows defining hooks before_render, around_render, after_render" do
      actual_html = ExampleWithBlock.new.to_s { "With block" }
      expected_html = normalize_html <<-HTML
        <span>Before</span>
        <h1>With block</h1>
        <span>After</span>
      HTML

      actual_html.should eq expected_html
    end
  end

  context "without block" do
    it "allows defining hooks before_render, around_render, after_render" do
      actual_html = ExampleWithoutBlock.new.to_s
      expected_html = normalize_html <<-HTML
        <span>Before</span>
        <h1>Without block</h1>
        <span>After</span>
      HTML

      actual_html.should eq expected_html
    end
  end
end
