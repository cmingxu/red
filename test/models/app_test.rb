# == Schema Information
#
# Table name: apps
#
#  id                 :integer          not null, primary key
#  name               :string
#  intances           :integer
#  service_id         :integer
#  current_version_id :integer
#  raw_config         :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class AppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
