class AdminController < ApplicationController
  def jobs
    @jobs=Delayed::Job.all
  end

  def seeds
    #@seeds = SeedUri.all
    #@seeds =SeedUri.joins("LEFT OUTER JOIN mementos On mementos.uri_id = seed_uris.id").group("seed_uris.id","seed_uris.uri").select("seed_uris.id","seed_uris.uri","mementos.is_thumbnail_captured").sum("is_thumbnail_captured")
     @seeds =SeedUri.joins("LEFT OUTER JOIN (select sum(mementos.is_thumbnail_captured) as captured, count(mementos.is_selected) as no_mementos, mementos.uri_id from mementos group by uri_id) as"+
               " gmementos on gmementos.uri_id = seed_uris.id").select("seed_uris.druid_id","IfNull(gmementos.captured,0) as captured","seed_uris.uri","IfNull(gmementos.no_mementos,0) as no_mementos")
  end

  def errors
     @errors=Delayed::Job.where.not("last_error"=>nil)
  end

  def thumbnails
    @druid = params[:druid]
    puts @druid
    #if druid.present? then
    #  uri_id = get_uri_id_from_druid druid
    #  @mementos = Memento.where uri_id: uri_id if uri_id.present?
    #end
  end
  
  def get_uri_id_from_druid druid
    seed = SeedUri.find_by druid_id: druid
    if seed.present? then
      return seed.id
    else
      return nil
    end
  end
end
