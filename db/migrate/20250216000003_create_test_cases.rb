# frozen_string_literal: true

class CreateTestCases < ActiveRecord::Migration[8.0]
  def change
    create_table :test_cases do |t|
      t.references :assignment, null: false, foreign_key: true
      t.text :input_data, null: false
      t.text :expected_output, null: false
      t.boolean :is_hidden, default: true, null: false
      t.integer :points, default: 5, null: false

      t.timestamps
    end
  end
end
