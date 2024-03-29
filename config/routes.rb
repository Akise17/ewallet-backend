Rails.application.routes.draw do
  devise_for :users,
             path: 'api/v1/users',
             controllers: { sessions: 'api/v1/users/sessions',
                            registrations: 'api/v1/users/registrations' }
  devise_for :teams,
             path: 'api/v1/teams',
             controllers: { sessions: 'api/v1/teams/sessions',
                            registrations: 'api/v1/teams/registrations' }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :test

      resources :transactions do
        collection do
          get :balance
        end
      end
    end
  end
end
