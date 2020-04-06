require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    subject { build(:post) }
    it { should validate_presence_of(:message) }
    it { should validate_length_of(:message).is_at_most(280) }
    it { should belong_to :user }
  end

  describe 'Valid Post' do
    it 'has a valid Post' do
      create(:post).should be_valid
    end
  end

  describe 'validations errors' do
    it 'fails' do
      expect{ create(:post, message: Faker::Lorem.paragraph_by_chars(number: 300)) }.should false
      expect{ create(:post, message: Faker::Lorem.paragraph_by_chars(number: 300)) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Message is too long (maximum is 280 characters)")
    end
  end

  describe 'User Posts' do
    let!(:user) { create(:user) }
    let!(:posts) { create_list(:post, 10, user: user) }
    it 'Posts' do
      expect(user.posts.count).to eq 10
    end
  end
end
