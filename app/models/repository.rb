# == Schema Information
#
# Table name: repositories
#
#  id              :integer          not null, primary key
#  name            :string
#  namespace_id    :integer
#  latest_tag_name :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Repository < ApplicationRecord
  has_many :repo_tags, dependent: :destroy
  belongs_to :namespace

  def latest_repo_tag
    self.repo_tags.where(name: self.latest_repo_tag).first
  end
end
