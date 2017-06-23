module Backend
  class Marathon
    attr_accessor :app
    def initialize app
      @app = app
    end

    def marathon_app_name
      self.app.service.slug + "/" + self.app.slug
    end

    def run(version = nil)
      version ||= self.app.versions.last
      begin
        ::Marathon::App.create self.app.with_version(version).marathon_hash.merge!("instances": 0)
        (self.app.current_version = version) && self.app.save
        self.app.backend_run!
      rescue ::Marathon::Error::MarathonError => e
        puts e
        puts e.details
      rescue ::Marathon::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      end
    end

    def stop
      begin
        ::Marathon::App.delete self.app.marathon_app_name
        self.app.backend_stop!
      rescue ::Marathon::Error::NotFoundError => e
        Rails.logger.debug e
      end

      if self.app.service.apps.running.present?
        begin
          ::Marathon::Group.delete self.app.service.name
        rescue ::Marathon::Error::NotFoundError => e
          Rails.logger.debug e
        end
      end
    end

    def marathon_app
      begin
        ::Marathon::App.get self.app.marathon_app_name
      rescue ::Marathon::Error::NotFoundError => e
      end
    end

    def suspend
      marathon_app.suspend!
    end

    def restart
      begin
        marathon_app.restart!
      rescue  ::Marathon::Error::MarathonError => e
        puts e
        puts e.details
      rescue ::Marathon::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      end
    end

    def change(version)
      version ||= self.app.versions.last
      begin
        self.app.marathon_app.change! self.app.with_version(version).marathon_hash
        self.app.current_version = version
      rescue ::Marathon::Error::MarathonError => e
        puts e
        puts e.details
      rescue ::Marathon::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      else
        self.app.save
      end
    end

    def rollback(version)
      marathon_app.roll_back! version
    end

    def scale(ins = 1)
      begin
        marathon_app.scale! ins
      rescue ::Marathon::Error::MarathonError => e
        puts e
        puts e.details
      rescue ::Marathon::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      end
    end

    def marathon_hash
      marathon_hash = {
        id: self.app.marathon_app_name,
        cpus: self.app.cpu.to_f,
        mem: self.app.mem,
        disk: self.app.disk,
        instances: self.app.instances,
        container: self.app.container_hash,
        env: self.app.env,
        labels: self.app.labels,
        fetch: self.app.uris.map {|u| { "uri": u }},
        constraints: self.app.constraints,
        cmd: self.app.cmd,
        healthChecks: [
          self.app.health_check ]
      }

      if self.app.cmd.present?
        marathon_hash[:cmd] = self.app.cmd
      end

      marathon_hash
    end

    def container_hash
      {
        type: "DOCKER",
        docker: {
          image: self.app.image,
          network: "BRIDGE",
          privileged: self.app.privileged,
          portMappings: self.app.portmappings,
          parameters: self.app.parameters,
        },
        volumes: self.app.volumes,
      }
    end

  end
end
