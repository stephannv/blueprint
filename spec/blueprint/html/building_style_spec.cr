require "../../spec_helper"

private class ButtonComponent
  include Blueprint::HTML

  style_builder do
    base "btn"

    variants do
      color {
        blue "btn-blue"
        red "btn-red"
      }

      size {
        xs "btn-xs"
        md "btn-md"
        lg "btn-lg"
      }

      outline {
        yes "btn-outline"
      }

      ghost {
        yes "btn-ghost"
        no "btn-normal"
      }

      clicked {
        yes "btn-clicked"
        no "btn-unclick"
      }
    end

    defaults color: :blue, size: :md
  end

  private def blueprint(&)
    a class: build_style(size: :xs, outline: true) do
      yield
    end
  end
end

private class SingleVariantStyle
  include Blueprint::HTML

  style_builder do
    variants do
      color {
        red "red"
        blue "blue"
      }
    end
  end
end

describe "style building" do
  it "allows defining a base class" do
    classes = ButtonComponent.build_style

    classes.starts_with?("btn ").should be_true
  end

  it "allows definig default variant options" do
    classes = ButtonComponent.build_style

    classes.should contain "btn-blue btn-md"
  end

  it "allows picking variants" do
    classes = ButtonComponent.build_style(color: :red, size: :lg)

    classes.should eq "btn btn-red btn-lg"
  end

  it "allows boolean values for yes/no variants" do
    classes = ButtonComponent.build_style(outline: :yes, ghost: false, clicked: true)

    classes.should contain "btn-outline btn-normal btn-clicked"
  end

  it "raises error passing an invalid variant" do
    msg = "`shadow` variant was not defined inside style_builder `variants` block."
    expect_raises(Blueprint::HTML::StyleBuilder::InvalidVariantError, msg) do
      ButtonComponent.build_style(shadow: :lg)
    end
  end

  it "raises error passing an invalid variant option" do
    msg = "`yellow` is an invalid option for color variant. Valid options are [:blue, :red]."
    bool_msg = "`confirm` is an invalid option for ghost variant. Valid options are [:yes, true, :no, false]."

    expect_raises(Blueprint::HTML::StyleBuilder::InvalidVariantOptionError, msg) do
      ButtonComponent.build_style(color: :yellow)
    end

    expect_raises(Blueprint::HTML::StyleBuilder::InvalidVariantOptionError, bool_msg) do
      ButtonComponent.build_style(ghost: :confirm)
    end
  end

  it "allows to build style inside components" do
    actual_html = ButtonComponent.new.to_html { "Build Style!" }
    expected_html = normalize_html <<-HTML
      <a class="btn btn-xs btn-outline btn-blue">Build Style!</a>
    HTML

    actual_html.should eq expected_html
  end

  # this tests that style_builder macro works without base, defaults or more variants
  it "allows to define style build with a single variant" do
    SingleVariantStyle.build_style.should eq ""

    SingleVariantStyle.build_style(color: :red).should eq "red"
  end
end
