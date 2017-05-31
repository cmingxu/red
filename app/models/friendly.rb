module Friendly
  extend ActiveSupport::Concern

  #included do |accessor|
    #accessor.class_eval do
      ##include FriendlyId
    #end
    
    #accessor.friendly_id :slug, use: [:slugged, :finders]
    #accessor.before_save do
      #self.slug = PinYin.of_string(self.name).join('-')
    #end
  #end
end


