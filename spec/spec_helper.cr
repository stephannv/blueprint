require "spec"
require "../src/blueprint"

def render(blueprint : Blueprint::HTML) : String
  blueprint.call
end
