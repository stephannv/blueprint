require "../../spec_helper"

private class Component
  include Blueprint::HTML

  private def blueprint(&)
    span { yield }
  end
end

describe "renderer" do
  it "renders Blueprint::HTML classes" do
    actual_html = Blueprint::HTML.build do
      render Component do
        "Hello"
      end
    end

    expected_html = "<span>Hello</span>"

    actual_html.should eq expected_html
  end

  it "renders Blueprint::HTML instances" do
    actual_html = Blueprint::HTML.build do
      render Component.new do
        "Hello"
      end
    end

    expected_html = "<span>Hello</span>"

    actual_html.should eq expected_html
  end

  it "renders strings" do
    actual_html = Blueprint::HTML.build do
      render "Hello"
    end

    expected_html = "Hello"

    actual_html.should eq expected_html
  end

  it "renders blocks" do
    actual_html = Blueprint::HTML.build do
      render -> { "He" + "llo" }
    end

    expected_html = "Hello"

    actual_html.should eq expected_html
  end

  it "renders nothing when renderable is nil" do
    actual_html = Blueprint::HTML.build do
      render nil
    end

    expected_html = ""

    actual_html.should eq expected_html
  end

  it "renders objects that respond `to_s`" do
    actual_html = Blueprint::HTML.build do
      render MarkdownLink.new("Example", "example.com")
    end

    expected_html = "[Example](example.com)"

    actual_html.should eq expected_html
  end
end
