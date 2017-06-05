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
  def info
    @info ||= Docker::info
  end

  def containers
    @containers ||= Docker::Container.all(all: true)
  end

  def volumes
    @volumes ||= Docker::Volume.all(all: true)
  end

  def images
    @images ||= Docker::Image.all(all: true)
  end

  def networks
    @networks ||= Docker::Network.all(all: true)
  end
end
