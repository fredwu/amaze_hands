FactoryGirl.define do
  lanes    = Strategies::LeanKit::Reducers::LaneMovement::LANES_ANALYSABLE
  services = Strategies::LeanKit::Reducers::ServiceLabelChange::SERVICE_LABELS

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

    trait :service_label do
      description { { service_from: services.sample, service_to: services.sample } }
    end
  end
end
