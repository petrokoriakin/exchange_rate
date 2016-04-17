require 'rails_helper'

RSpec.describe ExchangeRateController, type: :controller do
  describe 'GET index' do

    subject { controller.params[:conversion] }

    it 'params contain conversion_params' do
      get :index
      expect(subject).to include(:value, :date)
    end
  end

  describe 'GET convert' do
    let(:service_class) { ExchangeRateService }
    let(:date) { Time.now.to_date.to_s }
    let(:value) { '100' }
    let(:conversion_params) { {date: date, value: value} }

    context 'ExchangeRateService::InvalidDate error is raised' do
      subject { controller.flash[:notice] }

      before do
        allow(service_class).to receive(:new).and_raise(ExchangeRateService::InvalidDate)
        get :convert, conversion: conversion_params
      end

      it 'set flash messages' do
        expect(subject).to be_eql 'Data is not correct'
      end
    end

    context 'ExchangeRateService::DataRestrictionError is raised' do
      subject { controller.flash[:notice] }

      before do
        allow(service_class).to receive(:new).and_raise(ExchangeRateService::DataRestrictionError)
        get :convert, conversion: conversion_params
      end

      it 'set flash messages' do
        expect(subject).to be_eql 'You can not get info about exchange rates in specified year'
      end
    end

    context 'ExchangeRateService::NoRateDataError is raised' do
      subject { controller.flash[:notice] }

      before do
        allow(service_class).to receive(:new).and_raise(ExchangeRateService::NoRateDataError)
        get :convert, conversion: conversion_params
      end

      it 'set flash messages' do
        expect(subject).to be_eql 'No info for conversion, try update rate info or contact admin'
      end
    end

    context 'service can convert value' do
      let(:service_instance) { double('Instance of service').as_null_object }
      let(:result) { BigDecimal.new('100') }

      before do
        allow(service_class).to receive(:new).and_return(service_instance)
        allow(service_instance).to receive(:result).and_return(result)
      end

      it 'assign result to @result' do
        get :convert, conversion: conversion_params
        expect(assigns(:result)).to be_eql(result)
      end
    end

    it 'renders index' do
      expect(get :convert, conversion: conversion_params).to render_template(:index)
    end
  end
end
