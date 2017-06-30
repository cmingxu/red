# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  namespace_id   :integer
#  dockerfile     :text
#  user_id        :integer
#  group_id       :integer
#  version_format :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Project < ApplicationRecord
  belongs_to :namespace
end
