Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }

    resource :user, only: [:show, :update]
    get 'database', to: 'question#give_database' 
  end

  get '/*a', to: 'application#not_found'
  get '/', to: 'application#not_found'
end
