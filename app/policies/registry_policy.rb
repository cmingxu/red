class RegistryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def all?
    true
  end
end
