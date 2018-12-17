class JobsController < ApplicationController
  def retry
    id = id_param
    worker = Delayed::Worker.new
    begin
      job = Delayed::Job.find(id)
      status = worker.run job
      job.last_error
      if status
        head 200
      else
        head 500
      end
    rescue ActiveRecord::RecordNotFound => e
      Honeybadger.notify e
      head 404
    rescue => e
      Rails.logger.error e.inspect
      Honeybadger.notify e
      head 500
    end
  end

  def remove
    id = id_param
    begin
      records_count = Delayed::Job.delete(id)
      if records_count.present? && records_count.zero?
        head 404
      else
        head 200
      end
    rescue => e
      Honeybadger.notify e
      Rails.logger.error e.inspect
      head 500
    end
  end

  private

  def id_param
    params.require(:id)
  end
end
