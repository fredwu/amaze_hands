FactoryGirl.define do
  lanes = Reducers::LaneMovement::LANES_ANALYSABLE

  factory :card_action do
    date_time   { DateTime.now + rand }
    description { { text: 'Wow, amaze hands!' } }
    card_number { "P-#{rand(100..1000)}" }

    trait :created_in do
      description { { created_in: lanes.sample } }
    end

    trait :moved do
      description { { from: lanes.sample, to: lanes.sample } }
    end
  end
end
