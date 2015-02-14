FactoryGirl.define do
  factory :card_lane do
    card_number { "P-#{rand(100..1000)}" }
    lane        { Strategies::LeanKit::Lanes.with_traits(:analysable).sample }
    wait_days   { rand(5) }
  end
end
