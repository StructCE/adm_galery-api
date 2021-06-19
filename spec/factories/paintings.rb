FactoryBot.define do
  factory :painting do
    name { "MyString" }
    year { "MyString" }
    artist { nil }
    style { nil }
    description { "MyText" }
    currentplace { "MyString" }
  end
end
