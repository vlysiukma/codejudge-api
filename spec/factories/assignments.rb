# frozen_string_literal: true

FactoryBot.define do
  factory :assignment do
    sequence(:title) { |n| "Assignment #{n} title" }
    description { "Description of the assignment" }
    difficulty { "medium" }
    max_score { 100 }
  end
end
