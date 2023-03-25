require "../../spec_helper"

private class DummyPage
  include Blueprint::HTML

  register_element :v_btn
  register_element :card, "v-card"

  def blueprint
    div do
      v_btn(href: "#home", data: {id: 12, visible: true, disabled: false}) { "Home" }
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

  it "allows empty custom elements" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <v-card></v-card>
    HTML

    page.to_html.should contain expected_html
  end
end
