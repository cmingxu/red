# == Schema Information
#
# Table name: namespaces
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class NamespaceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
