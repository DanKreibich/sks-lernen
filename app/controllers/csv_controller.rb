require 'csv'

# Rules to create the CSV:
# 1. The CSV should be uploaded without any title row
# 2. The should be no double quotes "" and semi-colons ; in the data base entries
# 3. HTML tags need to be included, e.g. Line breaks are entered like <br/>
# 3. If new columns are added "move_csv_rows_into_theory_questions_db" needs to be adjusted

class CsvController < ApplicationController

  def new
  end

  # extracts the following colums from the csv and adds them to the DB
  def move_csv_rows_into_theory_questions_db(array)
    array.each do |row|
      new_db_record = TheoryQuestion.new(
        question_number: row[0].to_i,
        question: row[1],
        correct_answer: row[2],
        question_main_category: row[3],
        question_sub_category: row[4])
      new_db_record.save
      puts new_db_record
    end
  end

  def upload_success_page
  end

  def create
    raw_data_array = CSV.read(params[:file], col_sep: ";") # "params[:file]" fetches the csv and defines ";" as separator
    move_csv_rows_into_theory_questions_db(raw_data_array)
    redirect_to(csv_upload_success_page_path)
    puts "++++++#{raw_data_array.count} records have been added to the database++++++"
  end

end

