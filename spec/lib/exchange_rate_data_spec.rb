require 'rails_helper'

RSpec.describe ExchangeRateData do
  describe '.new' do
    context 'with options' do
      arr_options = [
          :store,
          :parser,
          :http_lib,
          :skip_rows,
          :load_link,
          :period_column,
          :rate_column,
      ]

      arr_options.each do |option_name|
        context "option #{option_name}" do
          let(:options) { {}.tap { |h| h[option_name] = double(option_name.to_s) } }
          subject { described_class.new(options).send(option_name) }

          it 'set option to specified value' do
            expect(subject).to be_eql options[option_name]
          end
        end
      end
    end

    context 'without options' do
      default_options = {
          store: ExchangeRate,
          parser: CSV,
          http_lib: RestClient,
          skip_rows: 5,
          load_link: ExchangeRateData::LOAD_LINK,
          period_column: 0,
          rate_column: 1,
      }

      default_options.each do |option_name, default_value|
        context "option #{option_name}" do
          subject { described_class.new.send(option_name) }

          it "return default value for #{option_name}" do
            expect(subject).to be_eql default_value
          end
        end
      end
    end
  end

  describe '#import_to_store' do
    let(:store) { double('Store') }
    let(:instance_object) { described_class.new(store: store) }
    let(:period) { Time.now.to_date.to_s }
    let(:rate) { 1.5 }
    let(:actual_rate) { [period, rate] }
    let(:actual_rates) { [actual_rate] }
    subject { instance_object.import_to_store }

    before do
      allow(instance_object).to receive(:actual_rates).and_return(actual_rates)
    end

    it 'saves actual rates' do
      expect(store).to receive(:create).with(period: period, rate: rate)
      subject
    end
  end
end
