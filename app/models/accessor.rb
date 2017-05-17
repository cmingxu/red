module Accessor
  extend ActiveSupport::Concern

  included do |accessor|
    %w(service service_template namespace).each do |resource|
      accessor.has_many :permissions, as: :accessor, dependent: :destroy
      accessor.has_many "accessible_#{resource.pluralize}".to_sym, through: :permissions, source: :resource, source_type: resource.classify
      accessor.has_many "adminable_#{resource.pluralize}".to_sym, -> { where("`permissions`.access=#{Permission.accesses[:admin]}") }, through: :permissions, source: :resource, source_type: resource.classify
      accessor.has_many "writeable_#{resource.pluralize}".to_sym, -> { where("`permissions`.access<=#{Permission.accesses[:write]}") }, through: :permissions, source: :resource, source_type: resource.classify
      accessor.has_many "readable_#{resource.pluralize}".to_sym, -> { where("`permissions`.access<=#{Permission.accesses[:read]}") }, through: :permissions, source: :resource, source_type: resource.classify
    end

    def access_resource(resource, access=:view)
      obj =  Permission.find_or_initialize_by(resource_type: resource.class.to_s, resource_id: resource.id, accessor_type: self.class.to_s, accessor_id: self.id)
      obj.send("#{access.to_sym}!")
    end

    # will be implemented in AccessorExtend for user
    def can_read?(resource)
      scope_name = resource.class.to_s.downcase.pluralize
      self.send("readable_#{scope_name}").where("`permissions`.resource_type = ? AND `permissions`.resource_id = ?",  resource.class.to_s, resource.id).exists?
    end

    # will be implemented in AccessorExtend for user
    def can_write?(resource)
      scope_name = resource.class.to_s.downcase.pluralize
      self.send("writable_#{scope_name}").where("`permissions`.resource_type = ? AND `permissions`.resource_id = ?",  resource.class.to_s, resource.id).exists?
    end

    # will be implemented in AccessorExtend for user
    def can_admin?(resource)
      scope_name = resource.class.to_s.downcase.pluralize
      self.send("adminable_#{scope_name}").where("`permissions`.resource_type = ? AND `permissions`.resource_id = ?",  resource.class.to_s, resource.id).exists?
    end
  end
end

