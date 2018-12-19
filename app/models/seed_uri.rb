# frozen_string_literal: true

class SeedUri < ApplicationRecord
  scope :seed_info, lambda {
    joins('LEFT OUTER JOIN (select sum(mementos.is_thumbnail_captured) as captured, count(mementos.is_selected) as no_mementos, mementos.uri_id from mementos group by uri_id) as' \
               ' gmementos on gmementos.uri_id = seed_uris.id').select('seed_uris.druid_id', 'IfNull(gmementos.captured,0) as captured', 'seed_uris.uri', 'IfNull(gmementos.no_mementos,0) as no_mementos')
  }
end
