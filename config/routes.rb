Rails.application.routes.draw do
  resources :participants

  resources :experiences

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'main#index'
  get "main/index"
  get "main/admin_manage"
  match "main/sign_up/:group", to: "main#sign_up", via: [:get, :post]
  match "lookup", to: "main#lookup", via: [:get, :post]
  get "main/register"
  get "main/edit_patron"
  get "main/update_patron"
  get "main/change_admin_role"
  get "main/patron_list"
  get "main/patron_list_export"
  get "main/inactive_patrons"
  get "main/experience_list"
  get "main/award_list"
  get "main/award_patron"
  get "main/revoke_award"
  get "main/mark_got_kit"
  get "main/mark_got_prize"
  get "main/mark_baby_complete"
  get "main/mark_inactive"
  get "main/search_by_name"
  get "main/search_by_card"
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
