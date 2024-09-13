require "../../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  private def blueprint
    render BasicComponent.new

    render ContentComponent.new do
      span "Passing content to component"
    end

    render ComplexComponent.new do |card|
      card.title { "My card" }
      card.body { "Card content" }
      footer "Footer tag"
    end
  end
end

private class BasicComponent
  include Blueprint::HTML

  private def blueprint
    header "Basic component"
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
    page = ExamplePage.new
    basic_component = normalize_html <<-HTML
      <header>Basic component</header>
    HTML

    page.to_s.should contain(basic_component)
  end

  it "can provide content to another blueprints" do
    page = ExamplePage.new
    content_component = normalize_html <<-HTML
      <div>
        <p>
          <span>Passing content to component</span>
        </p>
      </div>
    HTML

    page.to_s.should contain(content_component)
  end

  it "can use another blueprint methods" do
    page = ExamplePage.new
    complex_component = normalize_html <<-HTML
      <div class="bg-white border shadow">
        <div class="p-4 font-bold text-lg">My card</div>
        <div class="px-4 py-2">Card content</div>
        <footer>Footer tag</footer>
      </div>
    HTML

    page.to_s.should contain(complex_component)
  end
end
