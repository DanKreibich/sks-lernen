class CreateLearningLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :theory_question, null: false, foreign_key: true
      t.integer :counter_correctly_answered
      t.integer :counter_incorrectly_answered

      t.timestamps
    end
  end
end
