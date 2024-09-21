require "./tags"

class Blueprint::Form::Inputs
  include Tags

  @scope : Symbol | String

  def initialize(@scope = :""); end

  def blueprint(&)
    yield
  end
end
