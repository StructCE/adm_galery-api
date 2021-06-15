FactoryBot.define do
  factory :user do
    email { 'teste@teste.com' }
    name { 'Nome Para Teste' }
    password { 'TesteSenha' }
    password_confirmation { 'TesteSenha' }
    bio { 'Isso é apenas um teste...' }
    admin { false }

    factory :admin do
      admin { true }
    end
  end
end
