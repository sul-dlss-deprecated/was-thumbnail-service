module Api
  class ThumbnailsController < ApplicationController
    before_filter :find_uri, only: [:list]
    respond_to :json

    #https://was-thumbnail.example.org/api/v1/was/thumbnails/druid_id/jx731tz7613?format=json
    def list
      uri_id = @seed_uri[:id]
      @druid_id = @seed_uri[:druid_id]
      @memento_records = Memento.captured_thumbnails( uri_id )
    end

    private 
    def find_uri
      if params[:druid_id].present?
        @seed_uri = SeedUri.find_by(druid_id: params[:druid_id]) 
        render nothing: true, status: :not_found unless @seed_uri.present?
      elsif params[:uri].present?
        @seed_uri = SeedUri.find_by(uri: params[:uri]) 
        render nothing: true, status: :not_found unless @seed_uri.present?
      else
        render nothing: true, status: :not_found 
      end
    end
  end
end
