require "../../spec_helper"

private class DummyPage
  include Blueprint::HTML

  private def blueprint
    render BasicComponent.new

    render ContentComponent.new do
      span { "Passing content to component" }
    end

    render ComplexComponent.new do |card|
      card.title { "My card" }
      card.body { "Card content" }
      footer { "Footer tag" }
    end
  end
end

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

describe "Blueprint::HTML renderer" do
  describe "#render" do
    it "can render another blueprints" do
      page = DummyPage.new
      basic_component = <<-HTML.strip
        <header>Basic component</header>
      HTML

      page.to_html.should contain(basic_component)
    end

    it "can provide content to another blueprints" do
      page = DummyPage.new
      content_component = <<-HTML.strip
        <div><p><span>Passing content to component</span></p></div>
      HTML

      page.to_html.should contain(content_component)
    end

    it "can use another blueprint methods" do
      page = DummyPage.new
      complex_component = <<-HTML.strip.gsub(/\R\s+/, "")
        <div class="bg-white border shadow">
          <div class="p-4 font-bold text-lg">My card</div>
          <div class="px-4 py-2">Card content</div>
          <footer>Footer tag</footer>
        </div>
      HTML

      page.to_html.should contain(complex_component)
    end
  end
end
