class JobsController < ApplicationController
  def retry
    id = id_param
    worker = Delayed::Worker.new
    begin
      job = Delayed::Job.find(id)
      status = worker.run job
      job.last_error
      if status 
        render nothing: true, status: 200
      else
        render nothing: true, status: 500
      end
    rescue ActiveRecord::RecordNotFound=> e
      render nothing: true, status: 404
    rescue => e
      Rails.logger.error e.inspect
      render nothing: true, status: 500
    end
  end

  def remove
    id = id_param
    begin
      records_count = Delayed::Job.delete(id)
      if records_count.present? && records_count.zero?
        render nothing: true, status: 404
      else
        render nothing: true, status: 200
      end
    rescue => e
      Rails.logger.error e.inspect
      render nothing: true, status: 500
    end
  end

  private
  def id_param
    params.require(:id)
  end

end
