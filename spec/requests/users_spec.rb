require 'rails_helper'

RSpec.describe 'Chefs' do
  describe 'GET /chefs' do
    context 'シェフのレコードがあるとき' do
      let!(:chef) { create(:user, :with_type_chef) }

      it '200を返却すること' do
        get api_v1_users_path
        expect(response).to have_http_status(:ok)
      end

      it 'レスポンスの中身は1件のみであること' do
        get api_v1_users_path

        expect(response.parsed_body.length).to eq 1
      end

      it 'chefのレコードを返却すること' do
        get api_v1_users_path

        expect(response.parsed_body[0]).to include({
                                                     'id' => chef.id,
                                                     'name' => chef.name,
                                                     'description' => chef.description,
                                                     'follower_count' => chef.followers.count,
                                                     'recipe_count' => chef.recipes.count,
                                                     'thumbnail' => chef.thumnail,
                                                     'created_at' => chef.created_at.iso8601(3),
                                                     'updated_at' => chef.updated_at.iso8601(3)
                                                   })
      end
    end
  end

  describe 'GET /chefs/:id' do
    context 'シェフのレコードがあるとき' do
      let!(:chef) { create(:user, :with_type_chef) }
      let!(:chef_external_link) { create(:user_external_link, :with_url_type, user: chef) }

      it '200を返却すること' do
        get api_v1_user_path(chef)
        expect(response).to have_http_status(:ok)
      end

      it 'chefのレコードを返却すること' do
        get api_v1_user_path(chef)

        expect(response.parsed_body).to include({
                                                  'id' => chef.id,
                                                  'name' => chef.name,
                                                  'description' => chef.description,
                                                  'domain' => chef.domain,
                                                  'follower_count' => chef.followers.count,
                                                  'recipe_count' => chef.recipes.count,
                                                  'thumbnail' => chef.thumnail,
                                                  'created_at' => chef.created_at.iso8601(3),
                                                  'updated_at' => chef.updated_at.iso8601(3),
                                                  'external_links' => [
                                                    {
                                                      'url' => chef_external_link.url,
                                                      'type' => chef_external_link.url_type
                                                    }
                                                  ]
                                                })
      end
    end
  end
end
