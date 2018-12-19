# frozen_string_literal: true

module JobsHelper
  def get_thumbnail_uri(druid, memento_datetime)
    "#{Settings.image_stacks_uri}#{druid}%2F#{memento_datetime}/full/full/0/default.jpg"
  end
end
