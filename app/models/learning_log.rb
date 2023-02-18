class LearningLog < ApplicationRecord
  belongs_to :user
  belongs_to :theory_question
end
