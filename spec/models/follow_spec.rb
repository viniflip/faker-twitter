require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:follower).with_foreign_key('follower_id').class_name('User') }
    it { is_expected.to belong_to(:following).with_foreign_key('following_id').class_name('User') }
  end

  describe 'Valid Follow' do
    it 'has a valid User' do
      create(:follow).should be_valid
    end
  end

  describe 'Follow' do
    let!(:user) { create(:user) }
    let!(:following) { create(:user) }
    let!(:follow) { create(:follow, following: following, follower: user ) }
    it 'has a valid Follow' do
      follow.should be_valid
    end

    it 'User following' do
      expect(user.following.count).to eq(1)
      expect(user.following.first).to eq(following)
    end

    it 'Follow' do
      expect(follow.follower).to eq(user)
      expect(follow.following).to eq(following)
    end
  end
end
