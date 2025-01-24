require "../../spec_helper"

private class NoRender
  include Blueprint::HTML

  private def blueprint
    h1 { "This will not be rendered" }
  end

  private def blueprint(&)
    h1 { yield }
  end

  def render?
    false
  end
end

describe "conditional rendering" do
  context "when `#render?` returns false" do
    it "doesn't render the blueprint" do
      actual_html = Blueprint::HTML.build do
        render NoRender
        render NoRender.new
        render NoRender.new do
          "Hello World"
        end
      end

      actual_html.should eq ""
      NoRender.new.to_s.should eq ""
      NoRender.new.to_s { "Hello World" }.should eq ""
    end
  end
end
