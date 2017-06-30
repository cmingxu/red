# == Schema Information
#
# Table name: sites
#
#  id                  :integer          not null, primary key
#  docker_public_key   :string
#  mesos_addrs         :text
#  marathon_addrs      :text
#  graphna_addr        :string
#  mesos_state         :string
#  marathon_state      :string
#  graphna_state       :string
#  mesos_last_seen     :datetime
#  marathon_last_seen  :datetime
#  graphna_last_seen   :datetime
#  changelog           :text
#  version             :string
#  feature_flags       :text
#  marathon_username   :string
#  marathon_password   :string
#  backend_option      :string
#  swan_addrs          :string
#  mesos_leader_url    :string
#  marathon_leader_url :string
#  swan_leader_url     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  registry_domain     :string
#

require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
