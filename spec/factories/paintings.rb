FactoryBot.define do
  factory :painting do
    name { "Mona Lisa" }
    year { "1503-1506" }
    artist { nil }
    style { nil }
    description { "Mona Lisa, também conhecida como A Gioconda" }
    currentplace { "Museu do Louvre" }
  end
end
