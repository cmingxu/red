class ServiceTemplatePolicy < ApplicationPolicy
  attr_accessor :user, :record, :owner

  def initialize user, record, owner = nil
    @user = user
    @record = record
    @owner = owner
  end

  def create?
    if record.persisted?
      return user.union_writeable_service_templates.include? record
    else
      if owner.is_a?(Group)
        return user.groups.include? owner
      end

      if owner.is_a?(User)
        return owner == user
      end
    end
  end

  def update?
      user.union_writeable_service_templates.include? record
  end

  def destroy?
    user.adminable_service_templates.include? record
  end

  class Scope < Scope
    def resolve
      user.union_readable_service_templates(user.groups)
    end
  end
end
