require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  describe '.last_period' do
    subject { described_class.last_period }

    context 'last period exists' do
      let(:period) { Time.now.to_date }

      before do
        create :exchange_rate, period: period
        create :exchange_rate, period: 1.year.ago.to_date
      end

      it 'returns lats period date' do
        expect(subject).to be_eql(period)
      end
    end

    context 'last period does not exist' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '.rate_on' do
    subject { described_class.rate_on(period) }

    context 'passed period is bigger than any period in db' do
      let(:period) { 1.year.from_now }

      before do
        create :exchange_rate
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'passed period is in range between the earliest and latest period in db' do
      let!(:exchange_rate1) { create :exchange_rate, period: 1.day.ago }
      let!(:exchange_rate2) { create :exchange_rate, period: 3.day.ago }
      let(:period) { 2.days.ago }

      it 'returns first exchange rate in the same period or before specified period' do
        expect(subject).to be_eql(exchange_rate2.rate)
      end
    end
  end
end
