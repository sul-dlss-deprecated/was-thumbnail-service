class AdminController < ApplicationController
  def jobs
    @jobs = Delayed::Job.all
  end

  def seeds
    @seeds = SeedUri.seed_info
  end

  def errors
    @errors = Delayed::Job.where.not('last_error'=>nil)
  end

  def thumbnails
    @druid = druid_param
    # The view will do a call to the API to list the thumbs
  end
  
  def get_uri_id_from_druid(druid)
    seed = SeedUri.find_by druid_id: druid
    if seed.present? 
      return seed.id
    else
      return nil
    end
  end
  
  private
  def druid_param
    params.require(:druid)
  end
end
