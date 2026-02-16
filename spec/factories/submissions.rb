# frozen_string_literal: true

FactoryBot.define do
  factory :submission do
    association :assignment
    association :user
    source_code { "def solution(a,b); a+b; end" }
    language { "ruby" }
    status { "pending" }
    final_score { nil }
    test_results { [] }
  end
end
