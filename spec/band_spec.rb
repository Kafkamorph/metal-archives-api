require 'rails_helper'

describe 'Bands API', type: :request do
  it 'sends a band' do
    band_name = "Ancestors"
    band_id = "93304"

    get "/bands/#{band_name}/#{band_id}", nil \

    expect(response).to have_http_status(:success)

    json = JSON.parse(response.body)
    expect(json["band_name"]).to eq band_name
    expect(json["band_id"]).to eq "/bands/#{band_name}/#{band_id}"
  end
end