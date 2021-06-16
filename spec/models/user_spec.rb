require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    context 'when using standard user factory' do
      it { expect(build(:user)).to be_valid }
    end

    context 'when user is not an admin' do
      it { expect(build(:user).admin).to be false }
    end

    context 'when using admin user factory' do
      it { expect(build(:admin)).to be_valid }
    end

    context 'when user is admin' do
      it { expect(build(:admin).admin).to be true }
    end
  end

  describe 'validations' do

    context 'when admin field is nil' do
      it { expect(build(:user, admin: nil)).to be_valid }
    end

    context 'when user has no name' do
      it { expect(build(:user, name: nil)).to be_invalid }
    end

    context 'when user has no email' do
      it { expect(build(:user, email: nil)).to be_invalid }
    end

    context 'when user name is too short' do
      it { expect(build(:user, name: 'te')).to be_invalid }
    end

    context 'when email is not in a valid format' do
      it { expect(build(:user, email: 'testmail')).to be_invalid }
    end

    context 'when password is too short' do
      it { expect(build(:user, password: 'test', password_confirmation: 'test')).to be_invalid }
    end

    context 'when password confirmation does not match the password' do
      it { expect(build(:user, password: 'testSenha', password_confirmation: 'testsenha')).to be_invalid }
    end

    context 'when email is not unique' do
      before do
        create(:user, email: 'test@test.com.br')
      end

      it { expect(build(:user, email: 'test@test.com.br')).to be_invalid }
    end

    context 'when confidential field is nil' do
      it { expect(build(:user, confidential: nil)).to be_invalid }
    end

    context 'when confidential field is true' do
      it { expect(build(:user, confidential: true)).to be_valid }
    end
  end
end
