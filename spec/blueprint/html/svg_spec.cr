require "../../spec_helper"

private class Example
  include Blueprint::HTML

  private def blueprint
    svg width: 30, height: 10 do
      g fill: :red do
        rect x: 0, y: 0, width: 10, height: 10
        rect x: 20, y: 0, width: 10, height: 10
      end
    end
  end
end

describe Blueprint::HTML do
  it "allows SVG rendering" do
    example = Example.new

    example.to_html.should eq <<-HTML.strip.gsub(/\R\s+/, "")
      <svg width="30" height="10">
        <g fill="red">
          <rect x="0" y="0" width="10" height="10"></rect>
          <rect x="20" y="0" width="10" height="10"></rect>
        </g>
      </svg>
    HTML
  end
end
