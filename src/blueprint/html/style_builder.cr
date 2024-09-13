module Blueprint::HTML::StyleBuilder
  class InvalidVariantError < Exception; end

  class InvalidVariantOptionError < Exception; end

  macro build_style(**styles)
    ([
      {% if @type.class.has_method?(:style_builder_base_classes) %}
        {{@type}}.style_builder_base_classes,
      {% end %}

      {% for variant, option in styles %}
        {% if @type.class.has_method?("style_builder_#{variant}_variant") %}
          {{@type}}.style_builder_{{variant}}_variant({{option}}),
        {% else %}
          raise({{@type}}::InvalidVariantError.new("`{{variant}}` variant was not defined inside style_builder `variants` block.")),
        {% end %}
      {% end %}

      {% if @type.has_constant?("STYLE_BUILDER_DEFAULT_VARIANT_OPTIONS") %}
        {% used_variants = styles.keys %}
        {% for variant, option in STYLE_BUILDER_DEFAULT_VARIANT_OPTIONS %}
          {% unless used_variants.includes?(variant) %}
            {{@type}}.style_builder_{{variant}}_variant({{option}}),
          {% end %}
        {% end %}
      {% end %}
  ] of String).join(" ")
  end

  macro style_builder(&block)
    __parse_style_builer_top_level_body__ do
      {{ block.body }}
    end
  end

  private macro __parse_style_builer_top_level_body__(&block)
    {% node = block.body %}

    {% if node.is_a?(Expressions) %}
      {% for expressions in node.expressions %}
        __parse_style_builer_top_level_node__ { {{ expressions }} }
      {% end %}
    {% elsif node.is_a?(Call) %}
      __parse_style_builer_top_level_node__ { {{ node }} }
    {% end %}
  end

  private macro __parse_style_builer_top_level_node__(&block)
    {% node = block.body %}

    {% if node.name == "base" %}
      __parse_style_builder_base_node__ { {{ node }} }
    {% elsif node.name == "variants" %}
      {% variants_node = node.block.body %}
      {% if variants_node.is_a?(Expressions) %}
        {% for expression in variants_node.expressions %}
          __parse_style_builder_variant_node__ { {{ expression }} }
        {% end %}
      {% elsif variants_node.is_a?(Call) %}
        __parse_style_builder_variant_node__ { {{ variants_node }} }
      {% end %}
    {% elsif node.name == "defaults" %}
      __parse_style_builder_defaults_node__ { {{ node }} }
    {% end %}
  end

  private macro __parse_style_builder_base_node__(&block)
    {% node = block.body %}

    def self.style_builder_base_classes
      {{ node.args.join(" ") }}
    end
  end

  private macro __parse_style_builder_defaults_node__(&block)
    {% node = block.body %}

    STYLE_BUILDER_DEFAULT_VARIANT_OPTIONS = {
      {% for named_argument in node.named_args %}
        {{named_argument.name.id}}: {{named_argument.value}},
      {% end %}
    }
  end

  private macro __parse_style_builder_variant_node__(&block)
    {% node = block.body %}
    {% body = node.block.body %}

    def self.style_builder_{{node.name}}_variant(value : Symbol | Bool) : String
      {% valid_options = [] of Symbol | Bool %}
      case value
        {% if body.is_a?(Call) %}
          {% valid_options << body.name.symbolize %}

          {% if body.name.id == "yes" %}
            {% valid_options << true %}
            when :{{body.name.id}}, true
          {% elsif body.name.id == "no" %}
            {% valid_options << false %}
            when :{{body.name.id}}, false
          {% else %}
            when :{{body.name.id}}
          {% end %}

          {{ body.args.join(" ") }}
        {% elsif body.is_a?(Expressions) %}
          {% for expression in body.expressions %}
            {% valid_options << expression.name.symbolize %}

            {% if expression.name.id == "yes" %}
              {% valid_options << true %}
              when :{{expression.name.id}}, true
            {% elsif expression.name.id == "no" %}
              {% valid_options << false %}
              when :{{expression.name.id}}, false
            {% else %}
              when :{{expression.name.id}}
            {% end %}

            {{ expression.args.join(" ") }}
          {% end %}
        {% end %}
      else
        raise InvalidVariantOptionError.new <<-TXT
          `#{value}` is an invalid option for {{node.name}} variant. Valid options are {{valid_options}}.
        TXT
      end
    end
  end
end
