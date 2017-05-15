module Accessible
  extend ActiveSupport::Concern

  included do |accessible|
    %w(group user).each do |accessor|
      accessible.has_many :permissions, as: :resource, dependent: :destroy
      accessible.has_many "adminable_#{accessor.pluralize}".to_sym, -> { where("`permissions`.access=#{Permission.accesses[:admin]}") }, through: :permissions, source: :resource, source_type: accessor.classify
      accessible.has_many "writable_#{accessor.pluralize}".to_sym, -> { where("`permissions`.access<=#{Permission.accesses[:write]}") }, through: :permissions, source: :resource, source_type: accessor.classify
      accessible.has_many "readable_#{accessor.pluralize}".to_sym, -> { where("`permissions`.access<=#{Permission.accesses[:read]}") }, through: :permissions, source: :resource, source_type: accessor.classify
    end
  end
end
