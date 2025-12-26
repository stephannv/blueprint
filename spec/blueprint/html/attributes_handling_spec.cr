require "../../spec_helper"

describe "attributes handling" do
  it "parses normal attributes" do
    actual_html = Blueprint::HTML.build do
      div class: "hello", id: "first" do
        "Blueprint"
      end
    end

    expected_html = normalize_html <<-HTML
      <div class="hello" id="first">Blueprint</div>
    HTML

    actual_html.should eq expected_html
  end

  it "converts attribute values to string" do
    actual_html = Blueprint::HTML.build do
      span id: 421, float: 2.4, md: MarkdownLink.new("Example", "example.com") do
        "Blueprint"
      end
    end

    expected_html = normalize_html <<-HTML
      <span id="421" float="2.4" md="[Example](example.com)">Blueprint</span>
    HTML

    actual_html.should eq expected_html
  end

  it "replaces `_` by `-` on Symbol attribute names" do
    actual_html = Blueprint::HTML.build do
      section v_model: "user.name", "@click": "doSomething" do
        "Blueprint"
      end
    end

    expected_html = normalize_html <<-HTML
      <section v-model="user.name" @click="doSomething">Blueprint</section>
    HTML

    actual_html.should eq expected_html
  end

  it "accepts Hash attributes" do
    actual_html = Blueprint::HTML.build do
      input({
        "data-on:mycustomevent__window" => "$result = evt.detail.value",
        "data-bind:foo" => true
      })

      div(id: "myDiv", aria: {enabled: "true"}, data: {"on:mycustomevent__window" => "$result = evt.detail.value" }) do
        "Hello"
      end
    end

    expected_html = normalize_html <<-HTML
      <input data-on:mycustomevent__window="$result = evt.detail.value" data-bind:foo>

      <div id="myDiv" aria-enabled="true" data-on:mycustomevent__window="$result = evt.detail.value">
        Hello
      </div>
    HTML

    actual_html.should eq expected_html
  end

  it "accepts boolean attributes" do
    actual_html = Blueprint::HTML.build do
      input disabled: true, checked: false, outline: "true", border: "false"
    end

    expected_html = normalize_html <<-HTML
      <input disabled outline="true" border="false">
    HTML

    actual_html.should eq expected_html
  end

  it "doesn't render nil attributes" do
    actual_html = Blueprint::HTML.build do
      div class: nil, data: {id: nil}
    end

    expected_html = normalize_html <<-HTML
      <div></div>
    HTML

    actual_html.should eq expected_html
  end

  it "expands NamedTuple attributes" do
    actual_html = Blueprint::HTML.build do
      nav aria: {target: "#home", selected: "false", enabled: true, hidden: false} do
        "Blueprint"
      end
    end

    expected_html = normalize_html <<-HTML
      <nav aria-target="#home" aria-selected="false" aria-enabled>Blueprint</nav>
    HTML

    actual_html.should eq expected_html
  end

  it "flattens, compacts and joins array attributes" do
    actual_html = Blueprint::HTML.build do
      div class: ["a", nil, "b", ["c", nil, "d"]] do
        "Blueprint"
      end
    end

    expected_html = normalize_html <<-HTML
      <div class="a b c d">Blueprint</div>
    HTML

    actual_html.should eq expected_html
  end
end
