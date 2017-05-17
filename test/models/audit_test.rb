# == Schema Information
#
# Table name: audits
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  when         :datetime
#  entity_type  :string
#  enetity_desc :string
#  action       :string
#  change       :text
#  entity_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class AuditTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
