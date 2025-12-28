require "../../spec_helper"

private class CustomCounter
  getter count : Int32 = 0

  def to_s
    @count += 1
    "btn-#{@count}"
  end
end

describe "attributes caching" do
  it "caches attributes" do
    custom_counter = CustomCounter.new

    actual_html = Blueprint::HTML.build do
      div class: custom_counter, id: "hello" do
        "Blueprint"
      end
    end

    repeated_actual_html = Blueprint::HTML.build do
      div class: custom_counter, id: "hello" do
        "Blueprint"
      end
    end

    expected_html = normalize_html <<-HTML
      <div class="btn-1" id="hello">Blueprint</div>
    HTML

    custom_counter.count.should eq 1

    actual_html.should eq expected_html

    repeated_actual_html.should eq expected_html
  end
end
