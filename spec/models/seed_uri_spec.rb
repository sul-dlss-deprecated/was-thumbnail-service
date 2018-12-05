# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SeedUri do
  describe 'validation' do
    let(:seed) { described_class.new(uri: uri) }
    subject { seed.valid? }

    context 'when it is valid' do
      let(:uri) { 'http://www.slac.stanford.edu/' }
      it { is_expected.to be true }
    end

    context 'when it is not valid' do
      let(:uri) { '"http://www.slac.stanford.edu/"' }
      it { is_expected.to be false }
    end
  end
end
