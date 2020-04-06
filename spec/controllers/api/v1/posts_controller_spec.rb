require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :request do
  include ApiHelper

  describe 'GET #index' do
    let!(:user) { create(:user) }
    let!(:posts) { create_list(:post, 10, user: user) }
    before { get "/api/v1/posts", headers: { "Authorization" => "Bearer #{authenticated_header(user)}" } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
    it 'returns posts from user' do
      json = JSON.parse(response.body)['posts']
      expect(json.count).to eq(10)
    end
  end

  describe 'GET #show' do
    let!(:post) { create(:post) }
    before { get "/api/v1/posts/#{post.id}", headers: { "Authorization" => "Bearer #{authenticated_header(post.user)}" } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns current post' do
      json = JSON.parse(response.body)['post']
      expect(json['id']).to eq(post.id)
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }
    let!(:valid_attributes) { attributes_for(:post) }
    before { post "/api/v1/posts/", headers: { "Authorization" => "Bearer #{authenticated_header(user)}" }, params: { :post => valid_attributes } }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns post' do
      json = JSON.parse(response.body)
      expect(json.keys).to match_array(%w(post))
    end
  end

end
