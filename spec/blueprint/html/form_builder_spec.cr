require "../../spec_helper"

private class CustomFormBuilder(T) < Blueprint::Form::Builder(T)
  def label(attribute : Symbol, value = nil, **html_options, &)
    div class: "label" do
      super(attribute, value, **html_options.merge(class: "label-content")) do
        span { yield }
      end
    end
  end

  def text_input(attribute : Symbol, **html_options)
    super(attribute, **html_options.merge(class: "form-input"))
  end

  def money_input(attribute : Symbol, **html_options)
    text_input(attribute, **html_options.merge(mask: "$#.##"))
  end
end

describe "form builder" do
  describe "#form_builder" do
    it "accepts html options" do
      actual_html = Blueprint::HTML.build do
        form_builder(action: "/search", method: :post) do |form|
        end
      end

      expected_html = normalize_html <<-HTML
        <form action="/search" method="post"></form>
      HTML

      actual_html.to_s.should eq expected_html
    end

    it "accepts custom form builders" do
      actual_html = Blueprint::HTML.build do
        form_builder(builder: CustomFormBuilder) do |form|
          form.label :name
          form.text_input :name

          form.money_input :balance
        end
      end

      expected_html = normalize_html <<-HTML
        <form>
          <div class="label">
            <label for="name" class="label-content">
              <span>Name</span>
            </label>
          </div>
          <input type="text" id="name" name="name" class="form-input">

          <input type="text" id="balance" name="balance" mask="$#.##" class="form-input">
        </form>
      HTML

      actual_html.to_s.should eq expected_html
    end
  end

  describe "#inputs" do
    it "allows building inputs without form builder" do
      actual_html = Blueprint::HTML.build do
        inputs do |builder|
          builder.label :name
          builder.text_input :name

          builder.radio_input :color, :red
          builder.label :color, "Red", :red
        end

        inputs :settings do |builder|
          builder.label :volume
          builder.range_input :volume, 1..99
        end
      end

      expected_html = normalize_html <<-HTML
        <label for="name">Name</label>
        <input type="text" id="name" name="name">

        <input type="radio" id="color_red" name="color" value="red">
        <label for="color_red">Red</label>

        <label for="settings_volume">Volume</label>
        <input type="range" id="settings_volume" name="settings[volume]" min="1" max="99">
      HTML
      actual_html.to_s.should eq expected_html
    end
  end

  describe "#label" do
    it "renders label" do
      actual_html = Blueprint::HTML.build do
        form_builder do |form|
          form.label :username

          form.label :email, "E-mail"

          form.label :password do
            plain "Password"
            whitespace
            span "(*required)"
          end

          form.label :upload, id: "upload_label", class: "form-label", for: "another_upload"

          form.label :color, "Red", value: :red
        end

        form_builder(scope: :search) do |form|
          form.label :title
        end
      end

      expected_html = normalize_html <<-HTML
        <form>
          <label for="username">Username</label>

          <label for="email">E-mail</label>

          <label for="password">Password <span>(*required)</span></label>

          <label id="upload_label" class="form-label" for="another_upload">Upload</label>

          <label for="color_red">Red</label>
        </form>

        <form>
          <label for="search_title">Title</label>
        </form>
      HTML

      actual_html.to_s.should eq expected_html
    end
  end

  {% for type in %i[color date datetime datetime_local email file hidden month number password search tel text time url week] %}
    describe "{{type.id}}_input" do
      it "renders input with type = {{type.id}}" do
        actual_html = Blueprint::HTML.build do
          form_builder do |form|
            form.{{type.id}}_input :x

            form.{{type.id}}_input :y, id: "custom_id", name: "custom_name"
          end

          form_builder(scope: :custom_scope) do |form|
            form.{{type.id}}_input :z
          end
        end

        expected_html = normalize_html <<-HTML
          <form>
            <input type="{{type.tr("_", "-").id}}" id="x" name="x">

            <input type="{{type.tr("_", "-").id}}" id="custom_id" name="custom_name">
          </form>

          <form>
            <input type="{{type.tr("_", "-").id}}" id="custom_scope_z" name="custom_scope[z]">
          </form>
        HTML

        actual_html.to_s.should eq expected_html
      end
    end
  {% end %}

  describe "#checkbox_input" do
    it "renders input with type = checkbox" do
      actual_html = Blueprint::HTML.build do
        form_builder do |form|
          form.checkbox_input :paid

          form.checkbox_input :admin, "yes", "no"

          form.checkbox_input :accepted, unchecked_value: nil
        end

        form_builder(scope: :user) do |form|
          form.checkbox_input :admin
        end
      end

      expected_html = normalize_html <<-HTML
        <form>
          <input type="hidden" name="paid" value="0">
          <input type="checkbox" id="paid" name="paid" value="1">

          <input type="hidden" name="admin" value="no">
          <input type="checkbox" id="admin" name="admin" value="yes">

          <input type="checkbox" id="accepted" name="accepted" value="1">
        </form>

        <form>
          <input type="hidden" name="user[admin]" value="0">
          <input type="checkbox" id="user_admin" name="user[admin]" value="1">
        </form>
      HTML

      actual_html.to_s.should eq expected_html
    end
  end

  describe "#radio_input" do
    it "renders input with type = radio" do
      actual_html = Blueprint::HTML.build do
        form_builder do |form|
          form.radio_input :color, :yellow

          form.radio_input :color, "red"

          form.radio_input :color, safe(:blue)
        end

        form_builder(scope: :theme) do |form|
          form.radio_input :color, :green
        end
      end

      expected_html = normalize_html <<-HTML
        <form>
          <input type="radio" id="color_yellow" name="color" value="yellow">

          <input type="radio" id="color_red" name="color" value="red">

          <input type="radio" id="color_blue" name="color" value="blue">
        </form>

        <form>
          <input type="radio" id="theme_color_green" name="theme[color]" value="green">
        </form>
      HTML

      actual_html.to_s.should eq expected_html
    end
  end

  describe "#range_input" do
    it "renders input with type = range" do
      actual_html = Blueprint::HTML.build do
        form_builder do |form|
          form.range_input :volume

          form.range_input :volume, min: 20, max: 40, step: 5

          form.range_input :volume, -20..20
        end

        form_builder(scope: :settings) do |form|
          form.range_input :volume, 0...10
        end
      end

      expected_html = normalize_html <<-HTML
        <form>
          <input type="range" id="volume" name="volume">

          <input type="range" id="volume" name="volume" min="20" max="40" step="5">

          <input type="range" id="volume" name="volume" min="-20" max="20">
        </form>

        <form>
          <input type="range" id="settings_volume" name="settings[volume]" min="0" max="10">
        </form>
      HTML

      actual_html.to_s.should eq expected_html
    end
  end

  describe "#submit" do
    it "renders submit input" do
      actual_html = Blueprint::HTML.build do
        form_builder do |form|
          form.submit

          form.submit "Save"

          form.submit "Update", class: "btn", name: "commit"
        end
      end

      expected_html = normalize_html <<-HTML
        <form>
          <input type="submit" value="Submit">

          <input type="submit" value="Save">

          <input type="submit" value="Update" class="btn" name="commit">
        </form>
      HTML

      actual_html.to_s.should eq expected_html
    end
  end

  describe "#reset" do
    it "renders reset input" do
      actual_html = Blueprint::HTML.build do
        form_builder do |form|
          form.reset

          form.reset "Resetar"

          form.reset "Clear", class: "btn", name: "commit"
        end
      end

      expected_html = normalize_html <<-HTML
        <form>
          <input type="reset" value="Reset">

          <input type="reset" value="Resetar">

          <input type="reset" value="Clear" class="btn" name="commit">
        </form>
      HTML

      actual_html.to_s.should eq expected_html
    end
  end
end
