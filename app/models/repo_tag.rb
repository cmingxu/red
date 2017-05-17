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
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RepoTag < ApplicationRecord
  belongs_to :repository
  belongs_to :namespace

  belongs_to :user
end
