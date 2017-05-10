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

class Version < ApplicationRecord
  validates :name, uniqueness: { scope: :app_id }
  belongs_to :app
end
