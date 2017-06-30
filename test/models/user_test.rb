# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string
#  name               :string
#  salt               :string
#  encrypted_password :string
#  icon               :text
#  bio                :text
#  role               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  auth               :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
