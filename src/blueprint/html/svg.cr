module Blueprint::HTML::SVG
  private def svg(**attributes) : Nil
    svg(**attributes) { }
  end

  private def svg(**attributes, &) : Nil
    render SVGComponent.new(**attributes) do |component|
      with component yield
    end
  end

  private struct SVGComponent(T)
    include Blueprint::HTML

    @attributes : T

    def self.new(**kwargs) : SVGComponent
      new kwargs
    end

    macro finished
      {% for tag in %w(a animate animateMotion animateTransform circle clipPath defs desc discard ellipse feBlend feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting feDisplacementMap feDistantLight feDropShadow feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur feImage feMerge feMergeNode feMorphology feOffset fePointLight feSpecularLighting feSpotLight feTile feTurbulence filter foreignObject g image line linearGradient marker mask metadata mpath path pattern polygon polyline radialGradient rect script set stop style svg switch symbol text textPath title tspan use view) %}
        register_element {{tag}}
      {% end %}
    end

    def initialize(attributes : T)
      {% T.raise "Expected T be NamedTuple, but got #{T}." unless T <= NamedTuple %}
      @attributes = attributes
    end

    private def blueprint(&) : Nil
      element :svg, **@attributes do
        yield
      end
    end
  end
end
