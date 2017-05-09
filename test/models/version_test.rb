# == Schema Information
#
# Table name: versions
#
#  id         :integer          not null, primary key
#  name       :string
#  raw_config :text
#  app_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class VersionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
