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

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
