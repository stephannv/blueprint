require "../../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  private def blueprint
    doctype
    div do
      plain "Hello"
      b { "World" }
    end

    i { "Hi" }
    whitespace
    plain "User"

    comment "This is an html comment"
    comment MarkdownLink.new("Comment", "comment.example.com")

    div do
      raw safe("<script>Dangerous script</script>")
    end
  end
end

describe "utils" do
  describe "#plain" do
    it "renders plain text" do
      page = ExamplePage.new

      page.to_s.should contain("<div>Hello<b>World</b></div>")
    end
  end

  describe "#doctype" do
    it "renders HTML 5 doctype declaration" do
      page = ExamplePage.new

      page.to_s.should contain("<!DOCTYPE html>")
    end
  end

  describe "#comment" do
    it "renders an html comment" do
      page = ExamplePage.new

      page.to_s.should contain("<!--This is an html comment-->")
    end

    it "accepts any objects that respond `#to_s`" do
      page = ExamplePage.new

      page.to_s.should contain("<!--[Comment](comment.example.com)-->")
    end
  end

  describe "#whitespace" do
    it "renders an whitespace" do
      page = ExamplePage.new

      page.to_s.should contain("<i>Hi</i> User")
    end
  end

  describe "#unsafe_raw" do
    it "renders content without escaping" do
      page = ExamplePage.new

      page.to_s.should contain("<script>Dangerous script</script>")
    end
  end
end
