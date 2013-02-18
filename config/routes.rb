BreakpointApp::Application.routes.draw do
  root :to => 'seasons#index'

  devise_for :users

  resources :seasons do
    resources :practices, :only => [:index, :new]
    resources :matches, :only => [:index, :new]
    resources :team_members, :only => :index do
      collection do
        get 'edit'
        put 'update'
      end
    end
  end

  resources :practices do
    resources :practice_sessions
    member do
      post 'notify'
    end
  end

  resources :matches do
    resources :match_availabilities
    member do
      post 'notify'
      get 'edit_lineup' => 'match_lineups#edit'
    end
  end
end

