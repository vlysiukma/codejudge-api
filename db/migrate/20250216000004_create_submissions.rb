# frozen_string_literal: true

class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions, id: :uuid do |t|
      t.references :assignment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :source_code, null: false
      t.string :language, null: false
      t.string :status, null: false, default: "pending"
      t.integer :final_score
      t.text :instructor_comment
      t.integer :manual_score
      t.jsonb :test_results, default: []

      t.timestamps
    end
  end
end
