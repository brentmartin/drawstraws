Rails.application.routes.draw do
  resources :straws, only: :create

  root to: "landing#index"
end
