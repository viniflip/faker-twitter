require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of :email }
    it { should have_secure_password }
    it { should validate_length_of(:password).is_at_least(8).on(:create) }
  end

  describe 'relationships' do
    it { should have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:follower_relationships).with_foreign_key('following_id').class_name('Follow') }
    it { is_expected.to have_many(:followers).through(:follower_relationships).source(:follower) }
    it { is_expected.to have_many(:following_relationships).with_foreign_key('follower_id').class_name('Follow') }
    it { is_expected.to have_many(:following).through(:following_relationships).source(:following) }
  end


  describe 'validations errors message' do
    it 'fails' do
      expect{ create(:user, name: '') }.should false
      expect{ create(:user, name: '') }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
      expect{ create(:user, email: '') }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email can't be blank, Email is invalid")
      expect{ create(:user, email: 'xx@xxx.') }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invalid")
      expect{ create(:user, password: '') }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password can't be blank, Password is too short (minimum is 8 characters)")
      expect{ create(:user, password: '1112') }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password is too short (minimum is 8 characters)")
    end
  end

  describe 'Valid User' do
    it 'has a valid User' do
      create(:user).should be_valid
    end
  end

  describe 'many users' do
    let!(:users) { create_list(:user, 10) }
    it 'users count' do
      expect(users.count).to eq User.all.count
    end
  end

end
