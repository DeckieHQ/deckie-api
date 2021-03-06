FactoryGirl.define do
  factory :submission do
    association :profile, factory: :profile
    association :event,   factory: :event

    status { Fake::Submission.status }

    trait :pending do
      status 'pending'
    end

    trait :confirmed do
      status 'confirmed'
    end

    trait :to_event_closed do
      association :event, factory: :event_closed
    end

    trait :to_event_full do
      status 'pending'

      association :event, factory: :event_full
    end

    trait :to_event_ready do
      association :event, factory: [:event_with_attendees, :ready]
    end

    trait :to_event_not_ready do
      association :event, factory: [:event_with_attendees, :not_ready]
    end

    trait :to_event_almost_ready do
      association :event, factory: [:event_with_attendees, :almost_ready]
    end

    trait :to_event_with_one_slot_remaining do
      association :event, factory: :event_with_one_slot_remaining
    end
  end
end
