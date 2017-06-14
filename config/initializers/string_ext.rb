require 'cgi'

class String
  def escape_malformed
    self.gsub(/'/, "").gsub(/"/, "")
    CGI::escapeHTML(self)
  end
end
