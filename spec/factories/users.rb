# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    sequence(:username) { |n| "user#{n}" }
    role { "student" }
  end

  factory :instructor, parent: :user do
    role { "instructor" }
  end
end
