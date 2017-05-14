class Permission < ApplicationRecord
  enum access: [ :admin, :write, :read ]

  belongs_to :resource, polymorphic: true
  belongs_to :accessor, polymorphic: true
end
