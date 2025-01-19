require "../../spec_helper"

private class PageWithAttributeCaching
  include Blueprint::HTML
  include Blueprint::HTML::AttributeCaching

  private def blueprint
    ul id: "my-list" do
      li class: ["a", "b", "c"], data: {a: 1, b: true, c: false, d: :symbol, e: "string"} do
        a href: "<script>alert('unsafe')</script>" do
          "hello"
        end
      end
    end
  end
end

private class Page
  include Blueprint::HTML

  private def blueprint
    ul id: "my-list" do
      li class: ["a", "b", "c"], data: {a: 1, b: true, c: false, d: :symbol, e: "string"} do
        a href: "<script>alert('unsafe')</script>" do
          "hello"
        end
      end
    end
  end
end

describe "attributes caching" do
  it "outputs the html correctly" do
    Page.new.to_s.should eq PageWithAttributeCaching.new.to_s
  end
end
