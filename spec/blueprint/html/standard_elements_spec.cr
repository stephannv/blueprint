require "../../spec_helper"

private NORMAL_ELEMENTS = %i[
  a abbr address article aside audio b bdi bdo blockquote body button canvas caption cite code colgroup data
  datalist dd del details dfn dialog div dl dt em fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head
  header hgroup html i ins kbd label legend li main map mark menu meter nav noscript object ol optgroup option
  output p picture pre progress q rp rt ruby s samp script section slot small span strong style sub summary
  sup table tbody td template textarea tfoot th thead time title tr u ul var video
]
private VOID_ELEMENTS  = %i[area base br col embed hr img input link meta source track wbr]
private EMPTY_ELEMENTS = %i[iframe portal]

private class DummyPage
  include Blueprint::HTML

  private def blueprint
    {% for element in NORMAL_ELEMENTS %}
      {{element.id}}
      {{element.id}}(attribute: "test")
      {{element.id}} { "content" }
      {{element.id}}(attribute: "test") { "content" }
    {% end %}

    {% for element in VOID_ELEMENTS %}
      {{element.id}}
      {{element.id}}(attribute: "test")
    {% end %}

    {% for element in EMPTY_ELEMENTS %}
      {{element.id}}
      {{element.id}}(attribute: "test")
    {% end %}

    select_tag
    select_tag(attribute: "test")
    select_tag { "content" }
    select_tag(attribute: "test") { "content" }
  end
end

describe "Blueprint::HTML standard HTML elements" do
  it "defines all base HTML elements helper methods" do
    page = DummyPage.new
    expected_html = String.build do |io|
      NORMAL_ELEMENTS.each do |tag|
        io << "<" << tag << ">" << "</" << tag << ">"
        io << "<" << tag << " attribute=\"test\">" << "</" << tag << ">"
        io << "<" << tag << ">content" << "</" << tag << ">"
        io << "<" << tag << " attribute=\"test\">content" << "</" << tag << ">"
      end

      VOID_ELEMENTS.each do |tag|
        io << "<" << tag << ">"
        io << "<" << tag << " attribute=\"test\">"
      end

      EMPTY_ELEMENTS.each do |tag|
        io << "<" << tag << ">" << "</" << tag << ">"
        io << "<" << tag << " attribute=\"test\">" << "</" << tag << ">"
      end

      io << "<select></select>"
      io << "<select attribute=\"test\"></select>"
      io << "<select>content</select>"
      io << "<select attribute=\"test\">content</select>"
    end

    page.to_html.should eq expected_html
  end
end
