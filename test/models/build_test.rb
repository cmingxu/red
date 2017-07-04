# == Schema Information
#
# Table name: builds
#
#  id           :integer          not null, primary key
#  project_id   :integer
#  serial_num   :integer
#  version_name :string
#  build_status :string
#  slug         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class BuildTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
