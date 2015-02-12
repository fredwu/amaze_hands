FactoryGirl.define do
  lanes    = Strategies::LeanKit::Builders::CardAction::LANES
  services = Strategies::LeanKit::Builders::CardAction::SERVICES

  factory :card_action do
    date_time   { DateTime.now + rand }
    description { { text: 'Wow, amaze hands!' } }
    card_number { "P-#{rand(100, 999)}" }

    trait :moved do
      description { { from: lanes.sample, to: lanes.sample } }
    end

    trait :service do
      description { { service_from: services.sample, service_to: services.sample } }
    end
  end
end
