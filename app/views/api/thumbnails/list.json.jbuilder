extension = '.jpeg'
if Rails.configuration.jp2_required then
  extension='.jp2'
end
json.thumbnails @memento_records do |memento|
  json.memento_uri    memento.memento_uri
  json.memento_datetime memento.memento_datetime
  json.thumbanil_uri Rails.configuration.image_stacks_uri+@druid_id.sub("druid:","")+"/"+Was::ThumbnailService::Utilities.convert_date_to_14_digits(memento['memento_datetime'].to_s)+extension 
end