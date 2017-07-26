class PodsController < ApplicationController
  def index
    @pods = @k8client.get_pods
  end

  def new
  end
end
