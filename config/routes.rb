Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # root to: "laboratory_experiments#new"
  # post "laboratory/experiments", to: "laboratory_experiments#create"
  root to: "laboratory_experiments#create"
end
