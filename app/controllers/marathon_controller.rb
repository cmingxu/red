class MarathonController < SystemController
  def index
    @info = Marathon.info
    @apps = Marathon::App.list
    @groups = Marathon::Group.list.info[:groups]
  end

  def ping
    begin
      Marathon.ping
    rescue JSON::ParserError => e
      Site.seen_component(:marathon)
      Site.default.fetch_and_set_marathon_leader
      render json: "ok"
    rescue Exception => e
      render json: "fail"
    end
  end
end
