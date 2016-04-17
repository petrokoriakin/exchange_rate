require 'rails_helper'

RSpec.describe ExchangeRateService do
  let(:value) { 100 }
  let(:date) { Time.now.to_date.to_s }
  let(:converter) { double('Exchange converter') }

  describe '.new' do
    let(:invalid_date) { '' }

    context 'date is not correct' do
      subject { described_class.new(value, invalid_date) }

      it 'raises ExchangeRateService::InvalidDate error' do
        expect{ subject }.to raise_error(ExchangeRateService::InvalidDate)
      end
    end
  end

  describe '#result' do
    subject { instance.result }

    context 'data restriction' do
      let(:date) {'2010-01-01' }
      let(:restricted_year) { 2011 }
      let(:instance) { described_class.new(value, date, min_year: restricted_year) }

      it 'raises ExchangeRateService::DataRestrictionError' do
        expect { subject }.to raise_error(ExchangeRateService::DataRestrictionError)
      end
    end

    context 'converted value is nil' do
      let(:instance) { described_class.new(value, date, converter: converter) }

      before do
        allow(converter).to receive(:convert).with( any_args).and_return(nil)
      end

      it 'raises ExchangeRateService::NoRateDataError' do
        expect { subject }.to raise_error(ExchangeRateService::NoRateDataError)
      end
    end

    context 'value can be converted' do
      let(:instance) { described_class.new(value, date, converter: converter) }

      before do
        allow(converter).to receive(:convert).with( any_args).and_return(value)
      end

      it 'raises ExchangeRateService::NoRateDataError' do
        expect(subject).to be_eql(value)
      end
    end
  end
end
