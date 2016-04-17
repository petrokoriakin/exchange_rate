require 'rails_helper'

RSpec.describe ExchangeRateConverter do
  describe '.convert' do
    let(:rate_store) { double('Rate store') }
    let(:value) { 100 }
    let(:date) { Time.now.to_date }
    let(:rate) { 1.5 }
    subject { described_class.convert(value, date) }

    before do
      described_class.rate_store = rate_store
      allow(rate_store).to receive(:rate_on).with(date).and_return(rate)
    end

    context 'rate store contains rate on specified date' do
      before do
        allow(rate_store).to receive(:rate_on).with(date).and_return(rate)
      end

      it 'returns converted value' do
        expect(subject).to be_eql value/rate
      end
    end

    context 'rate store does not contain rate on specified date' do
      before do
        allow(rate_store).to receive(:rate_on).with(date).and_return(nil)
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '.rate_store' do
    subject { described_class.rate_store }

    before(:each) do
      described_class.instance_variable_set(:@rate_store, nil)
    end

    context 'rate store is not set' do
      let(:default_rate_store) { ExchangeRate }

      it 'returns default rate store' do
        expect(subject).to be_eql default_rate_store
      end
    end

    context 'rate store is set' do
      let(:rate_store) { double('Rate store') }

      before do
        described_class.rate_store = rate_store
      end

      it 'returns set rate store' do
        expect(subject).to be_eql rate_store
      end
    end
  end

  describe '.rate_store=' do
    let(:rate_store) { double('Rate store') }
    subject { described_class.rate_store = rate_store }


    before(:each) do
      described_class.instance_variable_set(:@rate_store, nil)
    end

    it 'keeps rate store into @rate_store' do
      subject
      expect(described_class.instance_variable_get(:@rate_store)).to be_eql rate_store
    end
  end
end
