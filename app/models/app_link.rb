# == Schema Information
#
# Table name: app_links
#
#  id            :integer          not null, primary key
#  service_id    :integer
#  alias         :string
#  input_app_id  :integer
#  output_app_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class AppLink < ApplicationRecord
  validates :alias, uniqueness: { scope: :input_app_id }
  belongs_to :service
  belongs_to :input_app, foreign_key: :input_app_id, class_name: 'App'
  belongs_to :output_app, foreign_key: :output_app_id, class_name: 'App'
end
