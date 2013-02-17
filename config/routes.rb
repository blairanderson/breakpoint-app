BreakpointApp::Application.routes.draw do
  root :to => 'seasons#index'

  devise_for :users

  resources :users
  resources :seasons do
    resources :practices
    resources :matches
    resources :players do
      collection do
        put 'update'
      end
    end
  end

  resources :practices do
    resources :practice_sessions
    resources :notifications
  end

  resources :matches do
    resources :match_availabilities
    resources :match_lineups do
      collection do
        get 'edit'
      end
    end
    resources :notifications
  end
end

