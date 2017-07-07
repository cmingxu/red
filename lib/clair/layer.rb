module Clair
  class Layer
    class << self
      def get name, digest
        Clair::Base.do_get "/layers/#{digest}?features&vulnerabilities"
      end

      def post name, digest, parent = ""
        token = Clair::Base.get_bear_token name

        layer = {
          "Format": "Docker",
          "Name": digest,
          "Path": "#{Clair::Base.registry_base}/v2/#{name}/blobs/#{digest}",
          "Headers": { "Authorization": "Bearer #{token}" },
          "ParentName": parent }

        body = { "Layer": layer }

        Clair::Base.do_post "/layers", body
      end

      def delete
      end
    end
  end
end
