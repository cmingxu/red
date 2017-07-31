class PodsController < ApplicationController
  def index
    @pods = @k8client.get_pods
  end

  def new
  end

  def create
    service = Kubeclient::Pod.new
    service.metadata = {}
    service.metadata.name = "nginx-#{rand 1000}"
    service.metadata.namespace = "default"
    service.spec = {}
    service.spec.ports =  [{
      'port' => 80,
      'targetPort' => 'web'
    }]
    service.spec.containers = [
      {
        image: "nginx:latest",
        name: "foobar"
      }
    ]
    fo = @k8client.create_pod(service)
    redirect_to pods_path
  end

  def destroy
    fo = @k8client.delete_pod(params[:name])
    redirect_to pods_path
  end
end
