require "../../spec_helper"

private ELEMENTS = %w(a animate animateMotion animateTransform circle clipPath defs desc discard ellipse feBlend
  feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting feDisplacementMap feDistantLight
  feDropShadow feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur feImage feMerge feMergeNode feMorphology feOffset
  fePointLight feSpecularLighting feSpotLight feTile feTurbulence filter foreignObject g image line linearGradient
  marker mask metadata mpath path pattern polygon polyline radialGradient rect script set stop style svg switch symbol
  text textPath title tspan use view
)

describe "SVG" do
  it "allows SVG rendering" do
    actual_html = Blueprint::HTML.build do
      svg width: 30, height: 10 do
        g fill: :red do
          rect x: 0, y: 0, width: 10, height: 10
          rect x: 20, y: 0, width: 10, height: 10
        end
      end
    end

    expected_html = normalize_html <<-HTML
      <svg width="30" height="10">
        <g fill="red">
          <rect x="0" y="0" width="10" height="10"></rect>
          <rect x="20" y="0" width="10" height="10"></rect>
        </g>
      </svg>
    HTML

    actual_html.should eq expected_html
  end

  it "defines all SVG element helper methods" do
    actual_html = Blueprint::HTML.build do
      svg

      svg viewBox: "0 0 100 100" do
        {% for element in ELEMENTS %}
          {{element.id}}
          {{element.id}}(attribute: "test")
          {{element.id}} { "content" }
          {{element.id}}(attribute: "test") { "content" }
        {% end %}
      end
    end

    expected_html = String.build do |io|
      io << "<svg></svg>"

      io << %(<svg viewBox="0 0 100 100">)
      ELEMENTS.each do |tag|
        io << "<" << tag << ">" << "</" << tag << ">"
        io << "<" << tag << " attribute=\"test\">" << "</" << tag << ">"
        io << "<" << tag << ">content" << "</" << tag << ">"
        io << "<" << tag << " attribute=\"test\">content" << "</" << tag << ">"
      end
      io << "</svg>"
    end

    actual_html.should eq expected_html
  end
end
