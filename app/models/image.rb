# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  name       :string
#  hash       :string
#  size       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Image < ApplicationRecord
end
