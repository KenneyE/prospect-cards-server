Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' }  do
    post "/", to: "graphql#execute"

    if Rails.env.development?
      post('/schema', to: 'graphql#schema')
    end
  end
  devise_for :users, defaults: { format: :json },
             controllers: {
               sessions: 'users/sessions', # invitations: 'users/invitations'
             }

  resources :listings, only: [] do
    collection do
      post :_msearch
    end
  end
end
