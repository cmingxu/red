# == Schema Information
#
# Table name: group_users
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  user_id    :integer
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GroupUser < ApplicationRecord
  enum role: [ :site_admin, :admin, :user ]

  belongs_to :group
  belongs_to :user
end
