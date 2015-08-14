module Api
  class SeedController < ApplicationController
    
    def create
      druid = druid_params
      uri = uri_params
      
      unless SeedUri.find_by(druid_id: druid).nil?
        render nothing: true, status: 409
        return
      end
      @seed_uri = SeedUri.new({:druid_id=>druid, :uri=> uri})
      @seed_uri.save
      render nothing: true, status: 200
    end
    
    private
      def uri_params
        params.require(:uri)
      end      
      def druid_params
        params.require(:druid)
      end

  end
end