# frozen_string_literal: true

require 'rails_helper'

describe 'application and dependency monitoring' do
  it '/status checks if Rails app is running' do
    visit '/status'
    expect(page.status_code).to eq 200
    expect(page).to have_text('Application is running')
  end
  it '/status/all checks if required dependencies are ok and also shows non-crucial dependencies' do
    visit '/status/all'
    expect(page).to have_text('PASSED')
    expect(page).to have_text('ruby_version')
    expect(page).to have_text('thumbnail_tmp_dir')
    expect(page).to have_text('digital_stacks_dir')
    expect(page).to have_text('external-wayback_timemap_root_url')
    expect(page).to have_text('delayed-job-size')
    expect(page).to have_text('OPTIONAL')
    expect(page).to have_text('external-purl_status_url') # non-crucial
    expect(page).to have_text('external-wayback_root_uri') # non-crucial
  end
end
