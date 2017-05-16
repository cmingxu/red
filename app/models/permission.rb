# == Schema Information
#
# Table name: permissions
#
#  id            :integer          not null, primary key
#  resource_type :string
#  resource_id   :integer
#  access        :integer
#  accessor_type :string
#  accessor_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Permission < ApplicationRecord
  enum access: [ :admin, :write, :read ]

  belongs_to :resource, polymorphic: true
  belongs_to :accessor, polymorphic: true
end
