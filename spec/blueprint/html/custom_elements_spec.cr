require "../../spec_helper"

private class Example
  include Blueprint::HTML

  register_element :v_btn
  register_element :card, "MyCard"

  private def blueprint(&)
    yield
  end
end

describe "custom elements" do
  it "allows custom elements rendering" do
    actual_html = Blueprint::HTML.build do
      element :foo, class: "bar", data: {tmp: true} do
        "Hello"
      end

      void_element :portal, class: "my-portal"
    end

    expected_html = normalize_html <<-HTML
      <foo class="bar" data-tmp>Hello</foo>
      <portal class="my-portal">
    HTML

    actual_html.should eq expected_html
  end

  it "allows custom elements registration" do
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
