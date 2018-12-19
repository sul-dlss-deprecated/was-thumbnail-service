# frozen_string_literal: true

module Api
  class ThumbnailsController < ApplicationController
    before_action :find_uri, only: [:list]
    respond_to :json

    #https://was-thumbnail.example.org/api/v1/was/thumbnails/druid_id/jx731tz7613?format=json
    def list
      uri_id = @seed_uri[:id]
      @druid_id = @seed_uri[:druid_id]
      @memento_records = Memento.captured_thumbnails(uri_id)
      @thumb_size = get_thumb_size(params[:thumb_size])
    end

    private
    def find_uri
      if params[:druid_id].present?
        @seed_uri = SeedUri.find_by(druid_id: params[:druid_id])
        head 404 unless @seed_uri.present?
      elsif params[:uri].present?
        @seed_uri = SeedUri.find_by(uri: params[:uri])
        head 404 unless @seed_uri.present?
      else
        head 404
      end
    end
    def get_thumb_size(param_thumb_size)
      if param_thumb_size.present? && param_thumb_size.to_i.positive?
        param_thumb_size.to_i
      else
        200
      end
    end
  end
end
