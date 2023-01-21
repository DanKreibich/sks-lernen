# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_01_21_132140) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "theory_questions", force: :cascade do |t|
    t.integer "questionnaire_number"
    t.integer "question_number"
    t.string "question"
    t.string "question_image"
    t.string "question_hint"
    t.string "correct_answer"
    t.string "answer_image"
    t.string "answer_additional_explanation"
    t.string "question_main_category"
    t.string "question_sub_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
