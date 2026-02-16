# frozen_string_literal: true

class CreateAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :assignments do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :difficulty
      t.integer :max_score, default: 0, null: false

      t.timestamps
    end
  end
end
