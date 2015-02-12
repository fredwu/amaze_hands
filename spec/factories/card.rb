FactoryGirl.define do
  factory :card do
    number 'P-217'
    type   :capability
    title  "Discard 'draft' prices"

    trait :bau do
      number 'P-243'
      type   :bau
      title  'Exception handling in/out of the controllers'
    end
  end
end
