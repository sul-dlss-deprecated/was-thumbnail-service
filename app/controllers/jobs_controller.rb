class JobsController < ApplicationController
  def retry
    id = params[:id]
    if id.present? then
      worker = Delayed::Worker.new
      begin
        job = Delayed::Job.find(id)
        status = worker.run job
        job.last_error
        if status then
          render nothing: true, status: 200
        else
          render nothing: true, status: 500
        end
      rescue ActiveRecord::RecordNotFound=> e
        render nothing: true, status: 404
      rescue => e
        render nothing: true, status: 500
      end
    else
      render nothing: true, status: 404
    end
  end

  def remove
    id = params[:id]
    if id.present? then
      begin
        records_count = Delayed::Job.delete(id)
        if records_count == 0 then            
          render nothing: true, status: 404
        else
          render nothing: true, status: 200
        end
      rescue => e
        puts e
        render nothing: true, status: 500
      end
    else
      render nothing: true, status: 404
    end
  end
end
