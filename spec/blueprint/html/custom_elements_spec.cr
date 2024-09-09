require "../../spec_helper"

private class DummyPage
  include Blueprint::HTML

  register_element :v_btn
  register_element :card, "MyCard"

  private def blueprint
    div do
      v_btn(href: "#home", data: {id: 12, visible: true, disabled: false}) { "Home" }
      v_btn("Contact", href: "#contact")
      card
    end
  end
end

describe "Blueprint::HTML custom elements registration" do
  it "allows custom elements definition" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <v-btn href="#home" data-id="12" data-visible>Home</v-btn>
    HTML

    page.to_html.should contain expected_html
  end

  it "allows passing content as first argument" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <v-btn href="#contact">Contact</v-btn>
    HTML

    page.to_html.should contain expected_html
  end

  it "allows empty custom elements" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <MyCard></MyCard>
    HTML

    page.to_html.should contain expected_html
  end
end
