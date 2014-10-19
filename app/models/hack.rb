class Hack < ActiveRecord::Base

  def self.set(name, value)
    model = find_by(name: name) || new(name: name)
    model.update_attributes(value: value)
    model
  end

  def self.get(name)
    model = find_by(name: name) || new
    model.value
  end
end
