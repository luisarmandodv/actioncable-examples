#*DTA Here!
Rails.application.routes.draw do
  resource  :session
  resources :examples

  resources :messages do
    resources :comments
  end

  resources :syncs
  resources :rick

  root 'examples#index'
end
