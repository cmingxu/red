class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.string :docker_public_key
      t.text :mesos_addrs
      t.text :marathon_addrs
      t.string :graphna_addr
      t.string :mesos_state
      t.string :marathon_state
      t.string :graphna_state
      t.datetime :mesos_last_seen
      t.datetime :marathon_last_seen
      t.datetime :graphna_last_seen

      t.text :changelog
      t.string :version

      t.text :feature_flags

      t.string :marathon_username
      t.string :marathon_password
      t.string :backend_option # swan / marathon + mesos / k8s
      t.string :swan_addrs


      t.string :mesos_leader_url
      t.string :marathon_leader_url
      t.string :swan_leader_url

      t.timestamps
    end
  end
end
