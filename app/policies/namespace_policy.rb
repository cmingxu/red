class NamespacePolicy < ApplicationPolicy
  attr_accessor :user, :record, :owner

  def initialize user, record, owner = nil
    @user = user
    @record = record
    @owner = owner
  end

  def pull?
    user.can_read? record
  end

  def push?
    user.can_admin? record
  end

  def update?
    user.can_admin? record
  end

  def all?
    user.can_admin? record
  end

  def create?
    if owner.is_a?(Group)
      return user.groups.include? owner
    end

    if owner.is_a?(User)
      return owner == user
    end
  end

  def destroy?
    user.adminable_namespaces.include? record
  end

  class Scope < Scope
    def resolve
      user.union_readable_namespaces(user.groups)
    end
  end
end
