module Auditable
  extend ActiveSupport::Concern

  included do |accessor|
      accessor.has_many :audits, as: :entity
  end
end

