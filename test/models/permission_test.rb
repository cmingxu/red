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

require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
