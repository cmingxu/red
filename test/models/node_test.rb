# == Schema Information
#
# Table name: nodes
#
#  id             :integer          not null, primary key
#  hostname       :string
#  state          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#  cpu            :integer
#  mem            :integer
#  docker_version :string
#  pubkey         :string
#

require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
