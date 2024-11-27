require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value(user.email).for(:email) }
    it { is_expected.not_to allow_value('invalid_email').for(:email) }

    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to allow_value('SecurePass1!').for(:password) }
    it do
      is_expected.not_to allow_value('password1')
        .for(:password)
        .with_message('Must include at least one uppercase letter and one special character')
    end
  end

  describe 'secure password' do
    it { is_expected.to have_secure_password }
  end
end
