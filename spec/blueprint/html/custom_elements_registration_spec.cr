require "../../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  register_element :v_btn
  register_element :card, "MyCard"

  private def blueprint
    div do
      v_btn(href: "#home", data: {id: 12, visible: true, disabled: false}) { "Home" }
      v_btn
      card
    end
  end
end

describe "custom elements registration" do
  it "allows custom elements definition" do
    page = ExamplePage.new
    expected_html = normalize_html <<-HTML
      <v-btn href="#home" data-id="12" data-visible>Home</v-btn>
    HTML

    page.to_s.should contain expected_html
  end

  it "allows empty custom elements" do
    page = ExamplePage.new
    expected_html = normalize_html <<-HTML
      <v-btn></v-btn>
    HTML

    page.to_s.should contain expected_html
  end

  it "allows defining custom tags" do
    page = ExamplePage.new
    expected_html = normalize_html <<-HTML
      <MyCard></MyCard>
    HTML

    page.to_s.should contain expected_html
  end
end
