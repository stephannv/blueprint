require "benchmark"

require "./blueprint_html"
require "./blueprint_raw_html"
require "./ecr"

require "../src/blueprint/version"

blueprint_html = BlueprintHTML::Page.new.to_html
blueprint_raw_html = BlueprintRawHTML::Page.new.to_html
ecr = ECR::Page.new.to_s # ECR is here just to have a base value to compare

raise "Different results" if blueprint_html != blueprint_raw_html && blueprint_html != ecr

Benchmark.ips do |x|
  x.report("Blueprint::HTML #{Blueprint::VERSION}") { BlueprintHTML::Page.new.to_html }
  x.report("Blueprint::RawHTML #{Blueprint::VERSION}") { BlueprintRawHTML::Page.new.to_html }
  x.report("ECR") { ECR::Page.new.to_s }
end
