require "../../spec_helper"

describe Blueprint::HTML do
  describe ".build" do
    it "renders given html structure" do
      html = Blueprint::HTML.build do
        h1 "Hello"

        div do
          span "World"
        end
      end

      html.should eq "<h1>Hello</h1><div><span>World</span></div>"
    end
  end
end
