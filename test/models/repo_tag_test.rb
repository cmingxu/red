# == Schema Information
#
# Table name: repo_tags
#
#  id            :integer          not null, primary key
#  name          :string
#  repository_id :integer
#  namespace_id  :integer
#  blob_size     :integer
#  owner_name    :string
#  digest        :string
#  url           :string
#  source        :string
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class RepoTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
