Rails.application.routes.draw do
  get "band_search/:band_name" => "band#index", defaults: {format: 'json'}

  get "bands/:band_name/:band_id" => "band#show", defaults: {format: 'json'}

  match '*all' => 'application#cors_options', via: :options
end