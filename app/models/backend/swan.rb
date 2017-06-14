module Backend
  class Swan
    attr_accessor :app
    def initialize app
      @app = app
    end

    def swan_app_name
      (self.app.service.name + self.app.name).gsub(/[^\w]+|\d+/, "") + "-" + self.app.service.owner.display.gsub(/[^\w]+|\d+/, "") + "-aliyun"
    end

    def run(version = nil)
      version ||= self.app.versions.last
      begin
        ::Swan::App.create self.app.with_version(version).swan_hash
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
        ::Swan::App.delete self.app.swan_app_name
        self.app.backend_stop!
      rescue ::Swan::Error::NotFoundError => e
        Rails.logger.debug e
      end

      if self.app.service.apps.running.present?
        begin
          ::Swan::App.delete self.app.service.name
        rescue ::Swan::Error::NotFoundError => e
          Rails.logger.debug e
        end
      end
    end

    def swan_app
      begin
        ::Swan::App.get self.app.swan_app_name
      rescue ::Swan::Error::NotFoundError => e
          Rails.logger.debug e
          false
      end
    end

    def rollback(version)
      swan_app.roll_back! version
    end

    def update(version = nil)
      version ||= self.app.versions.last
      begin
        ::Swan::App.update self.app.with_version(version).swan_hash
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

    def proceed(ins = 1)
      begin
        swan_app.proceed! ins
      rescue ::Swan::Error::SwanError => e
        puts e
        puts e.details
      rescue ::Swan::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      end
    end

    def scale_down(ins = 1)
      begin
        swan_app.scale_down ins
      rescue ::Swan::Error::SwanError => e
        puts e
        puts e.details
      rescue ::Swan::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      end
    end


    def scale_up(ins = 1)
      begin
        swan_app.scale_up ins
      rescue ::Swan::Error::SwanError => e
        puts e
        puts e.details
      rescue ::Swan::Error::UnexpectedResponseError => e
        puts e
        puts e.details
      end
    end

    def swan_hash
      swan_hash = {
        appName: (self.app.service.name + self.app.name).gsub(/[^\w]+|\d+/, ""),
        appVersion: self.app.current_version.name,
        runAs: self.app.service.owner.display.gsub(/[^\w]+|\d+/, ""),
        prioriry: 100,
        instances: 1,
        cpus: self.app.cpu.to_f,
        mem: self.app.mem,
        cmd: self.app.cmd,
        disk: self.app.disk,
        constraints: self.app.constraints,
        container: self.app.container_hash,
        labels: self.app.labels,
        uris: self.app.uris.map {|u| { "uri": u }},
        env: self.app.env,
        gateway: {
        enabled: false
      }#,
      #healthCheck: {}
      }

      if self.app.cmd.present?
        swan_hash[:cmd] = self.app.cmd
      end

      swan_hash
    end

    def container_hash
      {
        type: "DOCKER",
        docker: {
        image: self.app.image,
        network: self.app.network.downcase,
        privileged: self.app.privileged,
        #portMappings: self.app.portmappings,
      },
      volumes: self.app.volumes,
      }
    end

  end
end
