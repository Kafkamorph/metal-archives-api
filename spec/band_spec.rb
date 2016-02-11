require 'rails_helper'

describe 'Bands API', type: :request do
  it 'sends ancestors band' do
    ancestors = FactoryGirl.build(:ancestors_band)
    get "#{ancestors.band_id}", nil \

    expect(response).to have_http_status(:success)

    json = JSON.parse(response.body)
    expect(json["band_name"]).to eq ancestors.band_name
    expect(json["band_id"]).to eq ancestors.band_id
    expect(json["members"][0]["name"]).to eq "Mark McCoy"
    expect(json["members"][0]["associated_bands"][0]["band_name"]).to eq "Devouring Ghost"
    expect(json["members"][0]["associated_bands"][0]["band_id"]).to eq "/bands/Devouring_Ghost/3540397083"
  end

  it 'sends mutilation rites band' do
    mutilation_rites = FactoryGirl.build(:mutilation_rites_band)

    get "#{mutilation_rites.band_id}", nil \

    expect(response).to have_http_status(:success)

    json = JSON.parse(response.body)
    expect(json["band_name"]).to eq mutilation_rites.band_name
    expect(json["band_id"]).to eq mutilation_rites.band_id
    expect(json["members"][6]["name"]).to eq "Fran Araya"
    expect(json["members"][6]["status"]).to eq "Past"
    expect(json["members"][6]["associated_bands"]).to be_nil
    expect(json["members"][5]["name"]).to eq "Iain Deaderick"
    expect(json["members"][5]["associated_bands"]).to_not be_nil
  end
end