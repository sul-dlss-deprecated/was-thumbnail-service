require 'rails_helper'

RSpec.describe JobsController, :type => :controller do

  describe 'GET retry' do
    it 'returns 404 if there is no id passed' do
      expect{get :retry}.to raise_error(ActionController::ParameterMissing)
    end
    it 'retries a job from delayed job queue' do
      job = Delayed::Job.create({:handler=>''})
      expect(Delayed::Job.all.length).to eq(1)
      allow_any_instance_of(Delayed::Worker).to receive(:run).and_return(true)
      get :retry,  {:id=> job.id}
      expect(response).to have_http_status(:success)
    end
    it 'passes the job id to the find method' do
      expect(Delayed::Job).to receive(:find).with("1234").and_return( Delayed::Job.create({:id=>1234, :handler=>''}))
      get :retry,  {:id=> 1234}
    end
    it 'returns 404 if the requested job is not in delayed job queue' do
      expect(Delayed::Job.all.length).to eq(0)
      get :retry,  {:id=> 1234}
      expect(response).to have_http_status(404)
      expect(Delayed::Job.all.length).to eq(0)
    end
  end

  describe 'GET remove' do
    it 'deletes a job from delayed job queue' do
      job = Delayed::Job.create({:handler=>''})
      expect(Delayed::Job.all.length).to eq(1)
      
      get :remove,  {:id=> job.id}
      expect(response).to have_http_status(:success)
      expect(Delayed::Job.all.length).to eq(0)
    end
    it 'passes the job id to the delete method' do
      expect(Delayed::Job).to receive(:delete).with("1234").and_return(1)
      get :remove,  {:id=> 1234}
      expect(response).to have_http_status(:success)
    end
    it 'returns 404 if the requested job is not in delayed job queue' do
      expect(Delayed::Job.all.length).to eq(0)
      get :remove,  {:id=> 1234}
      expect(response).to have_http_status(404)
      expect(Delayed::Job.all.length).to eq(0)
    end
    it 'returns 404 if there is no id passed' do
      expect{get :remove}.to raise_error(ActionController::ParameterMissing)
    end
  end

end
