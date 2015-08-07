module Api
  class SeedController < ApplicationController
    def create
      druid = params[:druid]
      uri = params[:uri]
      
      if druid.present? and uri.present? then
        unless SeedUri.find_by( druid_id: druid).nil? then
          render  nothing: true, status: 409
          return
        end
        @seed_uri = SeedUri.new({:druid_id=>druid, :uri=> uri})
        @seed_uri.save
        render nothing: true, status: 200
      else
        render nothing: true, status: 400 
      end
    end  
  end
end