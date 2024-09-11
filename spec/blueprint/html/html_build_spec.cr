require "../../spec_helper"

describe "html build" do
  describe ".build" do
    it "renders given html structure" do
      actual_html = Blueprint::HTML.build do
        h1 "Hello"

        div do
          span "World"
        end
      end

      expected_html = normalize_html <<-HTML
        <h1>Hello</h1>

        <div>
          <span>World</span>
        </div>
      HTML

      actual_html.should eq expected_html
    end
  end
end
