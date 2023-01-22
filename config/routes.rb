Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  #homepage
  root to: "pages#home"

  # Everythin related to "Question Trainer"
  get "/overview", to: "questions#overview", as: "overview"
  get "/training", to: "questions#training", as: "training"
  get "/answer", to: "questions#answer", as: "answer"

  # Routes for everything related to uploading CSV data
  get "csv/new", to: "csv#new"
  post 'csv/new', to: 'csv#create'
  get 'csv/upload_success_page', to: 'csv#upload_success_page'
end
