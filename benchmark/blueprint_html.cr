require "../src/blueprint/html"

class BlueprintHTML::LayoutComponent
  include Blueprint::HTML

  def initialize(@title = "Example"); end

  def blueprint(&)
    html do
      head do
        title @title
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        link href: "/assets/tailwind.css", rel: "stylesheet"
      end

      body class: "bg-zinc-100" do
        nav class: "p-5", id: "main_nav" do
          ul do
            li(class: "p-5") { a("Home", href: "/") }
            li(class: "p-5") { a("About", href: "/about") }
            li(class: "p-5") { a("Contact", href: "/contact") }
          end
        end

        div class: "container mx-auto p-5" do
          yield
        end
      end
    end
  end
end

class BlueprintHTML::Page
  include Blueprint::HTML

  def blueprint
    render BlueprintHTML::LayoutComponent.new do
      h1 "Hi"

      table id: "test", class: "a b c d e f g" do
        tr do
          td id: "test", class: "a b c d e f g" do
            span "Hi"
          end

          td id: "test", class: "a b c d e f g" do
            span "Hi"
          end

          td id: "test", class: "a b c d e f g" do
            span "Hi"
          end

          td id: "test", class: "a b c d e f g" do
            span "Hi"
          end

          td id: "test", class: "a b c d e f g" do
            span "Hi"
          end
        end
      end
    end
  end
end
