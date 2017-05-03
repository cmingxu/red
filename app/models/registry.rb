# == Schema Information
#
# Table name: registries
#
#  id         :integer          not null, primary key
#  name       :string
#  hash       :string
#  size       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Registry < ApplicationRecord
end
