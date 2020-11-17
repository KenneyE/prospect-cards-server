# add access to web interface
require('sidekiq/web')

Rails.application.routes.draw do
  authenticate :user, ->(a) { a.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  namespace :v1, defaults: { format: 'json' } do
    post '/', to: 'graphql#execute'

    post('/schema', to: 'graphql#schema') if Rails.env.development?
  end
  devise_for :users,
             defaults: { format: :json },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations',
               confirmations: 'users/confirmations',
             }
  post '/stripe_webhook', to: 'stripe_webhooks#event', as: :stripe_webhooks
  resources :listings, only: [],defaults: { format: 'json' } do
    post '_msearch', on: :collection
  end
end
