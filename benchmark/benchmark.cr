require "benchmark"

require "./blueprint_html"
require "./cached_blueprint_html"
require "./ecr"

require "../src/blueprint/version"

blueprint_html = BlueprintHTML::Page.new.to_s
cached_blueprint_html = BlueprintHTML::PageWithCache.new.to_s
ecr = ECR::Page.new.to_s.chomp # ECR is here just to have a base value to compare

raise "Different results" if blueprint_html != ecr || blueprint_html != cached_blueprint_html

Benchmark.ips do |x|
  x.report("ECR") { ECR::Page.new.to_s }
  x.report("Cached Blueprint::HTML #{Blueprint::VERSION}") { BlueprintHTML::PageWithCache.new.to_s }
  x.report("Blueprint::HTML #{Blueprint::VERSION}") { BlueprintHTML::Page.new.to_s }
end
