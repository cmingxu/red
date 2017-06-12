module Backend
  class Swan
    attr_accessor :app
    def initialize app
      @app = app
    end

    def swan_app_name
      self.app.service.slug + "." + self.app.slug
    end

    def run(version = nil)
      version ||= self.app.versions.last
      begin
        ::Swan::App.create self.app.with_version(version).marathon_hash.merge!("instances": 0)
        (self.app.current_version = version) && self.app.save
        self.app.backend_run!
      rescue ::Swan::Error::SwanError => e
        puts e
        puts e.details
      rescue ::Swan::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      end
    end

    def stop
      begin
        ::Swan::App.delete self.app.marathon_app_name
        self.app.backend_stop!
      rescue ::Swan::Error::NotFoundError => e
        Rails.logger.debug e
      end

      if self.app.service.apps.running.present?
        begin
          ::Swan::Group.delete self.app.service.name
        rescue ::Swan::Error::NotFoundError => e
          Rails.logger.debug e
        end
      end
    end

    def marathon_app
      begin
        ::Swan::App.get self.app.marathon_app_name
      rescue ::Swan::Error::NotFoundError => e
      end
    end

    def suspend
      marathon_app.suspend!
    end

    def restart
      begin
        marathon_app.restart!
      rescue  ::Swan::Error::SwanError => e
        puts e
        puts e.details
      rescue ::Swan::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      end
    end

    def change(version)
      version ||= self.app.versions.last
      begin
        self.app.marathon_app.change! self.app.with_version(version).marathon_hash
        self.app.current_version = version
      rescue ::Swan::Error::SwanError => e
        puts e
        puts e.details
      rescue ::Swan::Error::UnexpectedResponseError => e
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
      rescue ::Swan::Error::SwanError => e
        puts e
        puts e.details
      rescue ::Swan::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      end
    end

    def marathon_hash
      marathon_hash = {
        id: self.app.marathon_app_name,
        cpus: self.app.cpu.to_f,
        mem: self.app.mem,
        instances: self.app.instances,
        #executor: "",
        container: self.app.container_hash,
        env: self.app.env,
        labels: self.app.labels,
        #fetch: self.app.uris.map {|u| { "uri": u }},
        healthChecks: [ ]
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
          network: self.app.network.upcase,
          privileged: self.app.privileged,
          #portMappings: self.app.portmappings,
        },
        volumes: self.app.volumes,
      }
    end

  end
end
