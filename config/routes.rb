Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post    'v1/api/create_user', to: 'api/users#create', defaults: { format: 'json' }

  get     'v1/api/view_zones', to: 'api/zones#index', defaults: { format: 'json' }
  get     'v1/api/view_zone/:domain_name', to: 'api/zones#show', defaults: { format: 'json' }
  post    'v1/api/create_zone', to: 'api/zones#create', defaults: { format: 'json' }
  put     'v1/api/update_zone/:domain_name', to: 'api/zones#update', defaults: { format: 'json' }
  delete  'v1/api/delete_zone/:domain_name', to: 'api/zones#delete', defaults: { format: 'json' }
end
