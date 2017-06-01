class PermissionPolicy < ApplicationPolicy
  attr_accessor :user, :record

  def initialize user, record
    self.user = user
    self.record = record
  end

  def update?
    return false if record.accessor == current_user
  end
end
