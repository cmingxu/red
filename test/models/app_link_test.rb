# == Schema Information
#
# Table name: app_links
#
#  id             :integer          not null, primary key
#  service_id     :integer
#  alias          :string
#  input_app_id   :integer
#  output_app_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  output_service :string
#

require 'test_helper'

class AppLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
