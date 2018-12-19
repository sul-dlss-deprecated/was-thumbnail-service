# frozen_string_literal: true

module Api
  class SeedController < ApplicationController
    def create
      druid = druid_params
      uri = uri_params

      return head(409) unless SeedUri.find_by(druid_id: druid).nil?
      @seed_uri = SeedUri.new(druid_id: druid, uri: uri)
      @seed_uri.save
      head 200
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
