class QuestionsController < ApplicationController


  # overview check which main categories there are and counts how many questions are included.
  def overview
    @questions = TheoryQuestion.all
    # creates array of the main question categories (https://stackoverflow.com/questions/8369812/rails-how-can-i-get-unique-values-from-column)
    main_categories = TheoryQuestion.all.map{|t| t.question_main_category}.uniq

    categories_and_number_of_questions_array = []
    correct_answers_per_category_array = []
    main_categories.each do |category|
      questions_counted_per_main_category = TheoryQuestion.where(:question_main_category => category).count
      categories_and_number_of_questions_array << [category, questions_counted_per_main_category]

      # this creates an array of id's, that can be checked for their correct answers
      question_ids = TheoryQuestion.where(:question_main_category => category).map(&:id)
      counter_correct_answers_per_category = 0
      question_ids.each do | question_id |

        if LearningLog.where(user_id: current_user.id, theory_question_id: question_id).exists?
          correct_answers_in_learning_log = LearningLog.where(user_id: current_user.id, theory_question_id: question_id)[0].counter_correctly_answered
          if correct_answers_in_learning_log >= 3
            counter_correct_answers_per_category +=1
          end
        end
      end
      correct_answers_per_category_array << [category, counter_correct_answers_per_category]

    end

    # transform array into a hash to display better in frontend (https://apidock.com/ruby/Enumerable/inject)
    @categories_and_number_of_questions_hash = Hash[*categories_and_number_of_questions_array.flatten]
    @correct_answers_per_category_hash = Hash[*correct_answers_per_category_array.flatten]
  end





  # returns the @image_name so it can be displayed in the frontend
  def check_if_image_exists(chosen_category, question_number)
    image_name = "#{chosen_category.downcase.tr(" ", "_")}_#{question_number}.jpg" #converts to lowercase and replaces spaces with underscores
    if File.file?("#{Rails.root}/app/assets/images/#{image_name}")
      @image_name = image_name #if image exists make it available for frontend
    end
  end







  # if a User has previously answered a questions, the following lines update the Learning Log
  # checks if a learning log already exists
  def adjust_counters (user_id, question_id, correctly_answered)
    if LearningLog.exists?(user_id: user_id, theory_question_id: question_id)
      learning_log_to_be_updated = LearningLog.where(user_id: user_id, theory_question_id: question_id)[0]
      if correctly_answered == "true"
        learning_log_to_be_updated.counter_correctly_answered += 1
        learning_log_to_be_updated.save
      else
        learning_log_to_be_updated.counter_incorrectly_answered += 1
        learning_log_to_be_updated.save
      end

    # if no Learning Log exists, create a new one and increase the respective counter
    else
      if defined?(correctly_answered) && correctly_answered == "true"
        new_learning_log = LearningLog.create(user_id: current_user.id, theory_question_id: question_id, counter_correctly_answered: 1, counter_incorrectly_answered: 0)
        new_learning_log.save
      elsif defined?(correctly_answered) && correctly_answered == "false"
        new_learning_log = LearningLog.create(user_id: current_user.id, theory_question_id: question_id, counter_correctly_answered: 0, counter_incorrectly_answered: 1)
        new_learning_log.save
      end
    end
  end





  # training displays a random question of the chosen category
  def training
    @chosen_category = params[:chosen_category]
    correctly_answered = params[:correctly_answered] # this returns a string not a bool (bad code)
    question_id = params[:question_id]

    # update the counters in the learning log
    adjust_counters(current_user.id, question_id, correctly_answered)


    question_pool = TheoryQuestion.where(question_main_category: @chosen_category).to_a # selects only questions from the chosen category
    selected_question = question_pool.sample
    @displayed_question = selected_question.question
    check_if_image_exists(@chosen_category, selected_question.question_number)

    # show the learning log counters in the frontend
    show_learning_log_of_specific_question(current_user.id, selected_question.id)

    # provide the following data so it can be passed to the answer screen
    @question_id = selected_question.id
    @sub_category = TheoryQuestion.where(id: @question_id)[0].question_sub_category # to display the sub category in the front end
  end

  def answer
    @question = TheoryQuestion.find_by(id: params[:question_id])
    @question_text = @question.question
    @question_answer = @question.correct_answer
    @chosen_category = params[:chosen_category] # needed to continue training in the same category
    @sub_category = @question.question_sub_category # to display the sub category in the front end
    check_if_image_exists(@chosen_category, @question.question_number)
    show_learning_log_of_specific_question(current_user.id, @question.id)
  end

  def show_learning_log_of_specific_question(user_id, question_id)
    if LearningLog.exists?(user_id: user_id, theory_question_id: question_id)
      current_learning_log = LearningLog.where(user_id: user_id, theory_question_id: question_id)
      @counter_correctly_answered = current_learning_log[0].counter_correctly_answered
      @counter_incorrectly_answered = current_learning_log[0].counter_incorrectly_answered
    else
      @counter_correctly_answered = 0
      @counter_incorrectly_answered = 0
    end
  end


end
