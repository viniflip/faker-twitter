require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  include ApiHelper

  describe 'GET unauthorized #index' do
    before { get "/api/v1/users" }

    it 'returns status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #index' do
    let!(:users) { create_list(:user, 10) }
    before { get "/api/v1/users", headers: { "Authorization" => "Bearer #{authenticated_header(users.first)}" } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns current user' do
      json = JSON.parse(response.body)['users']
      expect(json.count).to eq(10)
    end
  end

  describe 'GET #show' do
    let!(:users) { create_list(:user, 10) }
    before { get "/api/v1/users/#{users.second.id}", headers: { "Authorization" => "Bearer #{authenticated_header(users.third)}" } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns current user' do
      json = JSON.parse(response.body)['user']
      expect(json.keys).to match_array(%w(id name email posts follower_relationships following_relationships))
      expect(json['id']).to be_present
      expect(json['name']).to eq(users.second.name)
      expect(json['email']).to eq(users.second.email)
    end
  end

  describe 'POST #login' do
    let!(:user) { create(:user) }
    before { post "/api/v1/users/login", params: { :auth => {:email => user.email, :password => user.password } } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns jwt' do
      expect(response.headers.has_key?('Access-Token')).to be_present
    end
  end

  describe 'POST #create' do
    let!(:valid_attributes) { attributes_for(:user) }
    before { post "/api/v1/users/", params: { :user => valid_attributes } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns jwt' do
      expect(response.headers.has_key?('Access-Token')).to be_present
    end

    it 'returns user' do
      json = JSON.parse(response.body)['user']
      expect(json.keys).to match_array(%w(id name email posts follower_relationships following_relationships))
      expect(json['id']).to be_present
      expect(json['name']).to eq(valid_attributes[:name])
      expect(json['email']).to eq(valid_attributes[:email])
    end
  end

  describe 'POST #change_password' do
    let!(:user) { create(:user) }
    let!(:new_password) { Faker::Internet.password }
    before { post "/api/v1/users/change_password", params: { :auth => { :email => user.email, :password => user.password, :new_password => new_password } } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns message' do
      json = JSON.parse(response.body)
      expect(json['message']).to be_present
      expect(json['message']).to eq(I18n.t('change_password_successfully'))
    end
  end

  describe 'POST #follow' do
    let!(:users) { create_list(:user, 10) }
    before { post "/api/v1/users/#{users.second.id}/follow", headers: { "Authorization" => "Bearer #{authenticated_header(users.third)}" } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns status' do
      json = JSON.parse(response.body)
      expect(json['user']['following_relationships'].count).to eq 1
      expect(json['user']['following_relationships'][0]['following']['id']).to eq users.second.id
      expect(json['user']['following_relationships'][0]['follower']['id']).to eq users.third.id
    end
  end

  describe 'POST #unfollow' do
    let!(:users) { create_list(:user, 10) }
    before { post "/api/v1/users/#{users.second.id}/follow", headers: { "Authorization" => "Bearer #{authenticated_header(users.third)}" } }
    before { post "/api/v1/users/#{users.second.id}/unfollow", headers: { "Authorization" => "Bearer #{authenticated_header(users.third)}" } }

    it 'returns status' do
      json = JSON.parse(response.body)
      expect(json['user']['following_relationships'].count).to eq 0
    end
  end
end
