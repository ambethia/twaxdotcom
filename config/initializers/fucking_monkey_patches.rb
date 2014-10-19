# https://github.com/collectiveidea/delayed_job/issues/687
# https://github.com/tenderlove/psych/pull/205
class Psych::Visitors::YAMLTree
  def visit_ActiveRecord_Attribute o
    accept o.value
  end
end
