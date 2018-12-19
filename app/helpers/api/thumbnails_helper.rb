# frozen_string_literal: true

module Api
  module ThumbnailsHelper
    def build_thumbnail_uri(druid, memento_datetime, thumb_size)
      return "#{Settings.image_stacks_uri}#{druid}%2F#{memento_datetime}/full/#{thumb_size},/0/default.jpg"
    end
    def build_iiif_json_uri(druid, memento_datetime)
      return "#{Settings.image_stacks_uri}#{druid}%2F#{memento_datetime}/info.json"
    end
  end
end
