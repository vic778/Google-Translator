Rails.application.routes.draw do
  get 'translations/index'
  get 'translations/translate'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'translations#index'
  post 'translations/translate', as: :translate
end
