# == Schema Information
#
# Table name: service_templates
#
#  id         :integer          not null, primary key
#  name       :string
#  icon       :string
#  group_id   :integer
#  user_id    :integer
#  raw_config :text
#  desc       :string
#  readme     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#

require 'test_helper'

class ServiceTemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
