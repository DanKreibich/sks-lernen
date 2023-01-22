require 'csv'

# Rules to create the CSV:
# 1. The CSV should be uploaded without any title row
# 2. The should be no double quotes "" in the data base entries
# 3. If new columns are added "move_csv_rows_into_theory_questions_db" needs to be adjusted

class CsvController < ApplicationController

  def new
  end

  # extracts the following colums from the csv and adds them to the DB
  def move_csv_rows_into_theory_questions_db(array)
    array.each do |row|
      new_db_record = TheoryQuestion.new(
        question_number: row[0],
        question: row[1],
        correct_answer: row[2],
        question_main_category: row[3],
        question_sub_category: row[4])
      new_db_record.save
    end
  end

  def upload_success_page
  end

  def create
    raw_data_array = CSV.read(params[:file]) # "params[:file]" fetches the csv
    move_csv_rows_into_theory_questions_db(raw_data_array)
    redirect_to(csv_upload_success_page_path)
    puts "++++++#{raw_data_array.count} records have been added to the database++++++"
  end

end

