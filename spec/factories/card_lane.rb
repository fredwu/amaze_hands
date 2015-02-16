FactoryGirl.define do
  factory :card_lane do
    card_number { "P-#{rand(100..1000)}" }
    lane        { Strategies::LeanKit::Lanes.with_traits(:analysable).sample }
    wait_time   { rand(3) }
    cycle_time  { rand(5) }
  end
end
