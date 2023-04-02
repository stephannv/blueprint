require "../../spec_helper"

private class DummyPage
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

    comment { "This is an html comment" }
  end
end

describe "Blueprint::HTML utils" do
  describe "#plain" do
    it "renders plain text" do
      page = DummyPage.new

      page.to_html.should contain("<div>Hello<b>World</b></div>")
    end
  end

  describe "#doctype" do
    it "renders HTML 5 doctype declaration" do
      page = DummyPage.new

      page.to_html.should contain("<!DOCTYPE html>")
    end
  end

  describe "#comment" do
    it "renders an html comment" do
      page = DummyPage.new

      page.to_html.should contain("<!--This is an html comment-->")
    end
  end

  describe "#whitespace" do
    it "renders an whitespace" do
      page = DummyPage.new

      page.to_html.should contain("<i>Hi</i> User")
    end
  end
end
