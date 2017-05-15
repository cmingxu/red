module AccessorExtend
  extend ActiveSupport::Concern

  #def union_readable_services(group = [])
  #groups = group.is_a?(Array) ? group : [group]
  #self.readable_services.union(self.groups_services_scope(groups)).distinct
  #end

  #def groups_services_scope(groups)
  #Service.all.joins("inner join permissions on `permissions`.resource_id = `services`.id").
  #where("`permissions`.accessor_type = ?", 'Group').
  #where(" `permissions`.resource_type = ?","Service").
  #where("`permissions`.accessor_id in (?)", groups.map(&:id)).
  #where("`permissions`.access < ?", Permission.accesses[:read])
  #end

  included do |accessor|
    %w(service service_template).each do |resource|
      %w(admin read write).each do |access|
        define_method "union_#{access}able_#{resource.pluralize}" do |*groups|
          groups = groups.flatten
          self.send("#{access}able_#{resource.pluralize}").union(self.send("#{access}able_groups_#{resource.pluralize}_scope", groups)).distinct
        end

        define_method "#{access}able_groups_#{resource.pluralize}_scope" do |group|
          Service.all.joins("inner join permissions on `permissions`.resource_id = `#{resource.pluralize}`.id").
            where("`permissions`.accessor_type = ?", 'Group').
            where(" `permissions`.resource_type = ?","#{resource.classify}").
            where("`permissions`.accessor_id in (?)", group.map(&:id)).
            where("`permissions`.access <= ?", Permission.accesses[access.to_sym])
        end
      end
    end

    # will be implemented in AccessorExtend for user
    def can_read?(resource)
      scope_name = resource.class.to_s.downcase.pluralize
      self.send("union_readable_#{scope_name}", self.groups).include?(resource)
    end

    # will be implemented in AccessorExtend for user
    def can_write?(resource)
      scope_name = resource.class.to_s.downcase.pluralize
      self.send("union_writeable_#{scope_name}", self.groups).include?(resource)
    end

    # will be implemented in AccessorExtend for user
    def can_admin?(resource)
      scope_name = resource.class.to_s.downcase.pluralize
      self.send("union_adminable_#{scope_name}", self.groups).include?(resource)
    end
  end
end

