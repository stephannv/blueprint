require "../../spec_helper"

describe "output helpers" do
  describe "#plain" do
    it "renders plain text" do
      actual_html = Blueprint::HTML.build do
        div do
          plain "Hello"
          b { "World" }
        end
      end

      expected_html = normalize_html <<-HTML
        <div>
          Hello
          <b>World</b>
        </div>
      HTML

      actual_html.should eq expected_html
    end
  end

  describe "#doctype" do
    it "renders HTML 5 doctype declaration" do
      actual_html = Blueprint::HTML.build do
        doctype
      end

      expected_html = normalize_html <<-HTML
        <!DOCTYPE html>
      HTML

      actual_html.should eq expected_html
    end
  end

  describe "#comment" do
    it "renders an html comment" do
      actual_html = Blueprint::HTML.build do
        comment "This is an html comment"
      end

      expected_html = normalize_html <<-HTML
        <!--This is an html comment-->
      HTML

      actual_html.should eq expected_html
    end
  end

  describe "#whitespace" do
    it "renders an whitespace" do
      actual_html = Blueprint::HTML.build do
        i { "Hi" }
        whitespace
        plain "User"
      end

      expected_html = normalize_html <<-HTML
        <i>Hi</i> User
      HTML

      actual_html.should eq expected_html
    end
  end

  describe "#raw" do
    it "renders safe content without escaping" do
      actual_html = Blueprint::HTML.build do
        raw safe("<script>Dangerous script</script>")
      end

      expected_html = normalize_html <<-HTML
        <script>Dangerous script</script>
      HTML

      actual_html.should eq expected_html
    end
  end
end
