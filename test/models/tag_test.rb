# == Schema Information
#
# Table name: tags
#
#  id           :integer          not null, primary key
#  tagable_type :string
#  tagable_id   :integer
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
