class CreateTheoryQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :theory_questions do |t|
      t.integer :questionnaire_number
      t.integer :question_number
      t.string :question
      t.string :question_image
      t.string :question_hint
      t.string :correct_answer
      t.string :answer_image
      t.string :answer_additional_explanation
      t.string :question_main_category
      t.string :question_sub_category

      t.timestamps
    end
  end
end
