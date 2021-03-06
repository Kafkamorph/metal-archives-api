FactoryGirl.define do
  factory :band do
    factory :ancestors_band do
        band_name "Ancestors"
        band_id "/bands/Ancestors/93304"
    end
    factory :mutilation_rites_band do
        band_name "Mutilation Rites"
        band_id "/bands/Mutilation_Rites/3540306985"
    end
    factory :voivod_band do
        band_name "Voivod"
        band_id "/bands/Voivod/115"
    end
  end
end