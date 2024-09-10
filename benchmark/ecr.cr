require "ecr"

module ECR
  class Page
    def initialize(@title = "Example")
    end

    ECR.def_to_s("./benchmark/ecr_template.ecr")
  end
end
