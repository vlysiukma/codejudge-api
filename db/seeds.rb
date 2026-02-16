# frozen_string_literal: true

require "ffaker"

return if Rails.env.production?

puts "Seeding..."

# Clear in reverse dependency order
Submission.delete_all
TestCase.delete_all
Assignment.delete_all
User.delete_all

# Users: instructors and students
SEED_PASSWORD = "password123"

instructors = [
  { email: "instructor@codejudge.edu", username: "dr_smith", role: "instructor" },
  { email: "ta@codejudge.edu", username: "ta_jones", role: "instructor" }
]
instructors.each do |attrs|
  User.create!(attrs.merge(password: SEED_PASSWORD, password_confirmation: SEED_PASSWORD))
end

students = 15.times.map do |i|
  {
    email: "student#{i + 1}@codejudge.edu",
    username: FFaker::Internet.user_name.gsub(/[^a-z0-9_]/, "_").presence || "student_#{i + 1}",
    role: "student"
  }
end
students.each do |attrs|
  User.create!(attrs.merge(password: SEED_PASSWORD, password_confirmation: SEED_PASSWORD))
end

user_list = User.where(role: "student").to_a
instructor = User.find_by!(role: "instructor")

# Assignments: algorithmic problems (domain-relevant)
assignments_data = [
  {
    title: "Two Sum",
    description: "Given an array of integers and a target value, return indices of the two numbers that add up to the target. Assume exactly one solution exists.",
    difficulty: "easy",
    max_score: 100,
    test_cases: [
      { input_data: "2 7 11 15\n9", expected_output: "0 1", is_hidden: false, points: 25 },
      { input_data: "3 2 4\n6", expected_output: "1 2", is_hidden: false, points: 25 },
      { input_data: "1 5 3 9 2\n7", expected_output: "1 4", is_hidden: true, points: 50 }
    ]
  },
  {
    title: "Binary Search",
    description: "Implement binary search: given a sorted array and a target, return the index of target or -1 if not found.",
    difficulty: "medium",
    max_score: 100,
    test_cases: [
      { input_data: "1 3 5 7 9\n5", expected_output: "2", is_hidden: false, points: 20 },
      { input_data: "2 4 6 8\n3", expected_output: "-1", is_hidden: false, points: 20 },
      { input_data: "1 2 3 4 5 6 7 8 9 10\n10", expected_output: "9", is_hidden: true, points: 30 },
      { input_data: "10 20 30 40 50\n25", expected_output: "-1", is_hidden: true, points: 30 }
    ]
  },
  {
    title: "Fibonacci Sequence",
    description: "Return the n-th Fibonacci number (0-indexed). F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2).",
    difficulty: "easy",
    max_score: 80,
    test_cases: [
      { input_data: "0", expected_output: "0", is_hidden: false, points: 10 },
      { input_data: "1", expected_output: "1", is_hidden: false, points: 10 },
      { input_data: "10", expected_output: "55", is_hidden: false, points: 20 },
      { input_data: "15", expected_output: "610", is_hidden: true, points: 40 }
    ]
  },
  {
    title: "Valid Parentheses",
    description: "Given a string containing only '(', ')', '{', '}', '[' and ']', determine if the input is valid. Valid means open brackets are closed in the correct order.",
    difficulty: "easy",
    max_score: 100,
    test_cases: [
      { input_data: "()", expected_output: "true", is_hidden: false, points: 20 },
      { input_data: "()[]{}", expected_output: "true", is_hidden: false, points: 20 },
      { input_data: "(]", expected_output: "false", is_hidden: false, points: 20 },
      { input_data: "([)]", expected_output: "false", is_hidden: true, points: 40 }
    ]
  },
  {
    title: "Reverse Linked List",
    description: "Given the head of a singly linked list, reverse the list and return the new head. Input: space-separated node values. Output: space-separated values of the reversed list.",
    difficulty: "medium",
    max_score: 100,
    test_cases: [
      { input_data: "1 2 3 4 5", expected_output: "5 4 3 2 1", is_hidden: false, points: 25 },
      { input_data: "1 2", expected_output: "2 1", is_hidden: false, points: 25 },
      { input_data: "10 20 30", expected_output: "30 20 10", is_hidden: true, points: 50 }
    ]
  },
  {
    title: "Merge Two Sorted Arrays",
    description: "Merge two sorted integer arrays into one sorted array. Input: first line length of A, second line A, third line length of B, fourth line B. Output: space-separated merged array.",
    difficulty: "medium",
    max_score: 100,
    test_cases: [
      { input_data: "3\n1 3 5\n3\n2 4 6", expected_output: "1 2 3 4 5 6", is_hidden: false, points: 30 },
      { input_data: "2\n1 2\n2\n3 4", expected_output: "1 2 3 4", is_hidden: true, points: 70 }
    ]
  },
  {
    title: "Longest Increasing Subsequence",
    description: "Given an integer array, find the length of the longest strictly increasing subsequence.",
    difficulty: "hard",
    max_score: 150,
    test_cases: [
      { input_data: "10 9 2 5 3 7 101 18", expected_output: "4", is_hidden: false, points: 30 },
      { input_data: "0 1 0 3 2 3", expected_output: "4", is_hidden: false, points: 30 },
      { input_data: "7 7 7 7", expected_output: "1", is_hidden: true, points: 90 }
    ]
  }
]

assignments_data.each do |data|
  tc_data = data.delete(:test_cases)
  assignment = Assignment.create!(data)
  tc_data.each { |tc| assignment.test_cases.create!(tc) }
  assignment.update_column(:max_score, assignment.test_cases.sum(:points))
end

# Submissions: mix of completed (with scores) and a few pending
assignments = Assignment.all.to_a
statuses = %w[AC WA TLE RE CE]
assignments.each do |assignment|
  user_list.sample(8).each do |user|
    score = rand(0..assignment.max_score)
    test_results = assignment.test_cases.count.times.map do |i|
      status = score.positive? && rand > 0.3 ? "AC" : statuses.sample
      { "status" => status, "execution_time_ms" => rand(5..50), "actual_output" => status == "AC" ? "ok" : "" }
    end
    Submission.create!(
      assignment: assignment,
      user: user,
      source_code: "def solution(*args); args; end",
      language: %w[ruby python java cpp].sample,
      status: "completed",
      final_score: score,
      test_results: test_results
    )
  end
end

# A few submissions with instructor feedback
Submission.limit(5).each do |sub|
  sub.update!(
    instructor_comment: "Good approach. Consider edge cases for empty input.",
    manual_score: [sub.final_score + rand(0..10), sub.assignment.max_score].min
  )
end

puts "Seeded: #{User.count} users, #{Assignment.count} assignments, #{TestCase.count} test cases, #{Submission.count} submissions."
