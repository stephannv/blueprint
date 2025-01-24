require "../../spec_helper"

private class Example
  include Blueprint::HTML

  private def blueprint
    h1 { "Hello World" }
  end

  private def blueprint(&)
    h1 { yield }
  end

  private def around_render(&)
    span { "Before" }
    yield
    span { "After" }
  end
end

describe "around render" do
  context "with block" do
    it "allows wrapping component render" do
      actual_html = Example.new.to_s { "With block" }

      expected_html = normalize_html <<-HTML
        <span>Before</span>
        <h1>With block</h1>
        <span>After</span>
      HTML

      actual_html.should eq expected_html
    end
  end

  context "without block" do
    it "allows wrapping component render" do
      actual_html = Example.new.to_s

      expected_html = normalize_html <<-HTML
        <span>Before</span>
        <h1>Hello World</h1>
        <span>After</span>
      HTML

      actual_html.should eq expected_html
    end
  end
end
