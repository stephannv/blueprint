require "../../spec_helper"

private ELEMENTS = %w(a animate animateMotion animateTransform circle clipPath defs desc discard ellipse feBlend
  feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting feDisplacementMap feDistantLight
  feDropShadow feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur feImage feMerge feMergeNode feMorphology feOffset
  fePointLight feSpecularLighting feSpotLight feTile feTurbulence filter foreignObject g image line linearGradient
  marker mask metadata mpath path pattern polygon polyline radialGradient rect script set stop style svg switch symbol
  text textPath title tspan use view
)

private class DummyPage
  include Blueprint::HTML

  private def blueprint
    svg do
      {% for element in ELEMENTS %}
        {{element.id}}
        {{element.id}}(attribute: "test")
        {{element.id}} { "content" }
        {{element.id}}(attribute: "test") { "content" }
      {% end %}
    end
  end
end

describe "Bluprint::SVG::Component" do
  it "defines all SVG element helper methods" do
    page = DummyPage.new
    expected_html = String.build do |io|
      io << "<svg>"
      ELEMENTS.each do |tag|
        io << "<" << tag << ">" << "</" << tag << ">"
        io << "<" << tag << " attribute=\"test\">" << "</" << tag << ">"
        io << "<" << tag << ">content" << "</" << tag << ">"
        io << "<" << tag << " attribute=\"test\">content" << "</" << tag << ">"
      end
      io << "</svg>"
    end

    page.to_html.should eq expected_html
  end
end
