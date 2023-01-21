class QuestionsController < ApplicationController
  def overview
    @questions = TheoryQuestion.all
    # creates array of the main question categories (https://stackoverflow.com/questions/8369812/rails-how-can-i-get-unique-values-from-column)
    main_categories = TheoryQuestion.all.map{|t| t.question_main_category}.uniq

    categories_and_number_of_questions_array = []
    main_categories.each do |category|
      questions_counted_per_main_category = TheoryQuestion.where(:question_main_category => category).count
      categories_and_number_of_questions_array << [category, questions_counted_per_main_category]
    end

    # transform array into a hash to display better in frontend (https://apidock.com/ruby/Enumerable/inject)
    @categories_and_number_of_questions_hash = Hash[*categories_and_number_of_questions_array.flatten]
  end
end
