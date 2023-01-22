class QuestionsController < ApplicationController


  # overview check which main categories there are and counts how many questions are included.
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

  # returns the @image_name so it can be displayed in the frontend
  def check_if_image_exists(chosen_category, question_number)
    image_name = "#{chosen_category.downcase.tr(" ", "_")}_#{question_number}.jpg" #converts to lowercase and replaces spaces with underscores
    if File.file?("#{Rails.root}/app/assets/images/#{image_name}")
      @image_name = image_name #if image exists make it available for frontend
    end
  end

  # training displays a random question of the chosen category
  def training
    @chosen_category = params[:chosen_category]

    question_pool = TheoryQuestion.where(question_main_category: @chosen_category).to_a # selects only questions from the chosen category
    selected_question = question_pool.sample
    @displayed_question = selected_question.question
    check_if_image_exists(@chosen_category, selected_question.question_number)

    # provide the following data so it can be passed to the answer screen
    @question_id = selected_question.id
  end

  def answer
    question = TheoryQuestion.find_by(id: params[:question_id])
    @question_text = question.question
    @question_answer = question.correct_answer
    @chosen_category = params[:chosen_category] # needed to continue training in the same category
    check_if_image_exists(@chosen_category, question.question_number)
  end
end
