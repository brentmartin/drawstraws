Rails.application.routes.draw do
  resources :straws, only: :create
end
