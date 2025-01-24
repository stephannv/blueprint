require "../../spec_helper"

private class BasicComponent
  include Blueprint::HTML

  private def blueprint
    header { "Basic component" }
  end
end

private class ContentComponent
  include Blueprint::HTML

  private def blueprint(&)
    div do
      p do
        yield
      end
    end
  end
end

private class ComplexComponent
  include Blueprint::HTML

  private def blueprint(&)
    div class: "bg-white border shadow" do
      yield
    end
  end

  def title(&)
    div class: "p-4 font-bold text-lg" do
      yield
    end
  end

  def body(&)
    div class: "px-4 py-2" do
      yield
    end
  end

  def footer(&)
    div class: "p-4" do
      yield
    end
  end
end

describe "component rendering" do
  it "can render another blueprints" do
    actual_html = Blueprint::HTML.build do
      render BasicComponent.new
    end

    expected_html = normalize_html <<-HTML
      <header>Basic component</header>
    HTML

    actual_html.should eq expected_html
  end

  it "can provide content to another components" do
    actual_html = Blueprint::HTML.build do
      render ContentComponent.new do
        span { "Passing content to component" }
      end
    end

    expected_html = normalize_html <<-HTML
      <div>
        <p>
          <span>Passing content to component</span>
        </p>
      </div>
    HTML

    actual_html.should eq expected_html
  end

  it "can use another blueprint methods" do
    actual_html = Blueprint::HTML.build do
      render ComplexComponent.new do |card|
        card.title { "My card" }
        card.body { "Card content" }
        footer { "Footer tag" }
      end
    end

    expected_html = normalize_html <<-HTML
      <div class="bg-white border shadow">
        <div class="p-4 font-bold text-lg">My card</div>
        <div class="px-4 py-2">Card content</div>
        <footer>Footer tag</footer>
      </div>
    HTML

    actual_html.should eq expected_html
  end
end
