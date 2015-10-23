Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'web#index'

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

  get 'web' => 'web#index'

  post 'web' => 'web#index'

  get 'web/checkout' => 'web#checkout'

  get 'web/complete' => 'web#complete'

  get 'btn' => 'btn#index'

  get 'cl' => 'cl#index'

  post 'cl/setec' => 'cl#setec'

  post 'cl/getec' => 'cl#getec'

  post 'cl/doec' => 'cl#doec'

  post 'cl/crrp' => 'cl#crrp'

  post 'cl/crba' => 'cl#crba'

  post 'cl/trsr' => 'cl#trsr'

  post 'cl/gettr' => 'cl#gettr'

  post 'cl/getrp' => 'cl#getrp'

  post 'cl/dort' => 'cl#dort'

  post 'cl/mass' => 'cl#mass'

  get 'rest' => 'rest#index'

  post 'rest/call' => 'rest#call'

  post 'rest/pay' => 'rest#pay'

  post 'rest/dopay' => 'rest#dopay'

  post 'rest/payouts' => 'rest#payouts'

  post 'rest/getpay' => 'rest#getpay'

  get 'ad' => 'ad#index'

  post 'ad/pay' => 'ad#pay'

  post 'ad/execpay' => 'ad#execpay'

  post 'ad/paydt' => 'ad#paydt'

  post 'ad/refund' => 'ad#refund'

  post 'ad/preapp' => 'ad#preapp'

  get 'lg' => 'lg#index'

  get 'lg/callback' => 'lg#callback'

  post 'lg/auth' => 'lg#auth'

  post 'lg/seamless_ec' => 'lg#seamless_ec'

  get 'brain' => 'brain#index'

  post 'brain/checkout' => 'brain#checkout'

  get 'ipn' => 'ipn#indexget'

  post 'ipn' => 'ipn#index'

  get 'unity' => 'unity#index'

  get 'unity/pay' => 'unity#pay'

  get 'unity/charge' => 'unity#charge'

  get 'demo' => 'demo#index'

  get 'demo/checkout' => 'demo#checkout'

end
