class Memento < ApplicationRecord
  scope :captured_thumbnails, ->(uri_id) { where( 'uri_id = ? AND is_selected = 1 AND is_thumbnail_captured = 1', uri_id ) }
  scope :memento_records, ->(uri_id) { joins('INNER JOIN seed_uris on mementos.uri_id = seed_uris.id').where( 'seed_uris.uri = ?',uri_id )}
end
