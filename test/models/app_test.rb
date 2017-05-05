# == Schema Information
#
# Table name: apps
#
#  id                 :integer          not null, primary key
#  name               :string
#  backend            :string
#  cpu                :decimal(10, 2)
#  mem                :integer
#  disk               :integer
#  cmd                :string
#  args               :string
#  priority           :integer
#  runas              :string
#  constraints        :string
#  image              :string
#  network            :string
#  portmappings       :text
#  force_image        :boolean
#  privileged         :boolean
#  env                :text
#  volumes            :text
#  uris               :text
#  gateway            :text
#  health_check       :text
#  instances          :integer
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
