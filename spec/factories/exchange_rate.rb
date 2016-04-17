FactoryGirl.define do
  factory :exchange_rate do
    period Time.now.to_date
    rate 1
  end
end