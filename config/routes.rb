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
  post '/stripe_webhook', to: 'stripe_webhooks#event'
end
