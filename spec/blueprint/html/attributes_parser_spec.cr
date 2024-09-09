require "../../spec_helper"

private class DummyPage
  include Blueprint::HTML

  private def blueprint
    div "Normal attributes", class: "hello", id: "first"
    span "Non-string attribute values", id: 421, float: 2.4
    section "Transform attribute name", v_model: "user.name", "@click": "doSomething"
    input disabled: true, checked: false, outline: "true", border: "false"
    nav "Nested attributes", aria: {target: "#home", selected: "false", enabled: true, hidden: false}
    div "Array attributes", class: ["a", nil, "b", ["c", nil, "d"]]
  end
end

describe "Blueprint::HTML attributes parser" do
  it "parses normal attributes" do
    page = DummyPage.new
    div = <<-HTML.strip
      <div class="hello" id="first">Normal attributes</div>
    HTML

    page.to_html.should contain(div)
  end

  it "converts attribute values to string" do
    page = DummyPage.new
    span = <<-HTML.strip
      <span id="421" float="2.4">Non-string attribute values</span>
    HTML

    page.to_html.should contain(span)
  end

  it "replaces `_` by `-` on attribute names" do
    page = DummyPage.new
    section = <<-HTML.strip
      <section v-model="user.name" @click="doSomething">Transform attribute name</section>
    HTML

    page.to_html.should contain(section)
  end

  it "accepts boolean attributes" do
    page = DummyPage.new
    input = <<-HTML.strip
      <input disabled outline="true" border="false">
    HTML

    page.to_html.should contain(input)
  end

  it "expands nested attributes" do
    page = DummyPage.new
    nav = <<-HTML.strip
      <nav aria-target="#home" aria-selected="false" aria-enabled>Nested attributes</nav>
    HTML

    page.to_html.should contain(nav)
  end

  it "flattens, compacts and joins array attributes" do
    page = DummyPage.new
    nav = <<-HTML.strip
      <div class="a b c d">Array attributes</div>
    HTML

    page.to_html.should contain(nav)
  end
end
