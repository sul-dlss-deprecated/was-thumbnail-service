module Api
  module ThumbnailsHelper
    def build_thumbnail_uri(druid, memento_datetime)
      return "#{Rails.configuration.image_stacks_uri}#{druid}%2F#{memento_datetime}/full/200,/0/default.jpg"
    end
  end
end
