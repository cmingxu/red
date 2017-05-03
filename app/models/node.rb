# == Schema Information
#
# Table name: nodes
#
#  id         :integer          not null, primary key
#  hostname   :string
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Node < ApplicationRecord
end
