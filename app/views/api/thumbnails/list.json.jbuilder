json.thumbnails @memento_records do |memento|
  json.memento_uri    memento.memento_uri
  json.memento_datetime memento.memento_datetime
  json.thumbanil_uri Rails.configuration.image_stacks_uri+@druid_id+"/"+Was::ThumbnailService::Utilities.convert_date_to_14_digits(memento['memento_datetime'].to_s)+".jpeg" 
end