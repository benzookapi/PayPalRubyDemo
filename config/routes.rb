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

  post 'cl/call' => 'cl#call'

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

  post 'rest/token' => 'rest#token'

  get 'rest/cors' => 'rest#cors'

  get 'rest/invoice' => 'rest#invoice'

  get 'rest/ecqr' => 'rest#ecqr'

  get 'rest/call_qr' => 'rest#call_qr'

  post 'rest/fp' => 'rest#fp'

  get 'ad' => 'ad#index'

  post 'ad/call' => 'ad#call'

  post 'ad/pay' => 'ad#pay'

  post 'ad/execpay' => 'ad#execpay'

  post 'ad/paydt' => 'ad#paydt'

  post 'ad/refund' => 'ad#refund'

  post 'ad/preapp' => 'ad#preapp'

  get 'lg' => 'lg#index'

  get 'lg/callback' => 'lg#callback'

  post 'lg/auth' => 'lg#auth'

  get 'brain' => 'brain#index'

  post 'brain/checkout' => 'brain#checkout'

  post 'brain/checkout_ec' => 'brain#checkout_ec'

  post 'brain/create_cs' => 'brain#create_cs'

  post 'brain/vault' => 'brain#vault'

  post 'brain/search' => 'brain#search'

  post 'brain/refund' => 'brain#refund'

  post 'brain/capture' => 'brain#capture'

  get 'brain/get_token' => 'brain#get_token'

  get 'ipn' => 'ipn#indexget'

  post 'ipn' => 'ipn#index'

  get 'webhook' => 'webhook#indexget'

  post 'webhook' => 'webhook#index'

  get 'unity' => 'unity#index'

  get 'unity/pay' => 'unity#pay'

  get 'unity/charge' => 'unity#charge'

  get 'demo' => 'demo#index'

  get 'demo/checkout' => 'demo#checkout'

  get 'demo/complete' => 'demo#complete'

  get 'qr/agree' => 'qr#agree'

  get 'qr/createba' => 'qr#createba'

  get 'qr/pay' => 'qr#pay'

end
