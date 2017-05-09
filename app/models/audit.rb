# == Schema Information
#
# Table name: audits
#
#  id           :integer          not null, primary key
#  owner_type   :string
#  owner_id     :integer
#  when         :datetime
#  entity_type  :string
#  entity_id    :integer
#  enetity_desc :string
#  change       :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Audit < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :entity, polymorphic: true
end
