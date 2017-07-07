module Clair
  class Namespace
    class << self
      def list
        Clair::Base.do_get "/namespaces"
      end
    end
  end
end
