class PermissionPolicy < ApplicationPolicy
  attr_accessor :user, :record

  def initialize user, record
    self.user = user
    self.record = record
  end

  def update?
    self.user.can_admin? record
  end
end
