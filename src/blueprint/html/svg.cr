struct Blueprint::HTML::SVG(T)
  include Blueprint::HTML

  @attributes : T

  macro finished
    {% for tag in %w(a animate animateMotion animateTransform circle clipPath defs desc discard ellipse feBlend feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting feDisplacementMap feDistantLight feDropShadow feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur feImage feMerge feMergeNode feMorphology feOffset fePointLight feSpecularLighting feSpotLight feTile feTurbulence filter foreignObject g image line linearGradient marker mask metadata mpath path pattern polygon polyline radialGradient rect script set stop style svg switch symbol text textPath title tspan use view) %}
      register_element {{tag}}
    {% end %}
  end

  def initialize(**@attributes : **T)
  end

  private def blueprint(&) : Nil
    svg **@attributes do
      yield
    end
  end
end
