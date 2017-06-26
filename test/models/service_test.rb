# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  name       :string
#  desc       :string
#  favorite   :boolean
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#

require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
