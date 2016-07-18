FactoryGirl.define do
  factory :time_slot do
    begin_at { Fake::TimeSlot.begin_at }

    association :event, factory: [:event, :flexible]

    transient { comments_count 10 }

    trait :with_members do
      transient { members_count 10 }

      after(:create) do |time_slot, evaluator|
        create_list(:time_slot_submission, evaluator.members_count, time_slot: time_slot)
      end
    end
  end
end