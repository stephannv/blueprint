require "../../spec_helper"

private class Example
  include Blueprint::HTML

  register_element :v_btn
  register_element :card, "MyCard"

  private def blueprint(&)
    yield
  end
end

describe "custom elements registration" do
  it "allows custom elements definition" do
    actual_html = Example.new.to_s do |example|
      example.v_btn(href: "#home", data: {id: 12, visible: true, disabled: false}) { "Home" }
    end

    expected_html = normalize_html <<-HTML
      <v-btn href="#home" data-id="12" data-visible>Home</v-btn>
    HTML

    actual_html.should eq expected_html
  end

  it "allows empty custom elements" do
    actual_html = Example.new.to_s do |example|
      example.v_btn
    end

    expected_html = normalize_html <<-HTML
      <v-btn></v-btn>
    HTML

    actual_html.should eq expected_html
  end

  it "allows defining custom tags" do
    actual_html = Example.new.to_s do |example|
      example.card
    end

    expected_html = normalize_html <<-HTML
      <MyCard></MyCard>
    HTML

    actual_html.should eq expected_html
  end
end
