require 'rails_helper'

RSpec.describe 'Chefs' do
  describe 'GET /chefs' do
    context 'シェフのレコードがあるとき' do
      let!(:chef) { create(:user, :with_type_chef) }

      it '200を返却すること' do
        get api_v1_chefs_path
        expect(response).to have_http_status(:ok)
      end

      it 'レスポンスの中身は1件のみであること' do
        get api_v1_chefs_path

        expect(response.parsed_body.length).to eq 1
      end

      it 'chefのレコードを返却すること' do
        get api_v1_chefs_path

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
        get api_v1_chef_path(chef)
        expect(response).to have_http_status(:ok)
      end

      it 'chefのレコードを返却すること' do
        get api_v1_chef_path(chef)

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

  describe 'GET /api/v1/chefs/search' do
    context '有名シェフのレコードがあるとき' do
      let!(:chef) { create(:user, :with_type_chef, name: '山田太郎') }

      before do
        get '/api/v1/chefs/search', params: { keyword: '山田', page: 1 }
      end

      it '200 OKを返却すること' do
        expect(response).to have_http_status(:ok)
      end

      it 'レスポンスは1件のシェフを返却すること' do
        expect(response.parsed_body.length).to eq 1
      end

      it 'シェフのレコードを返却すること' do
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

    context 'キーワードが与えられていない時' do
      context 'キーワードが空の文字列の時' do
        before do
          create(:user, :with_type_chef, name: '山田太郎')
          create(:user, :with_type_chef, name: '山田花子')
          get '/api/v1/chefs/search', params: { keyword: '', page: 1 }
        end

        it '200 OKを返却すること' do
          expect(response).to have_http_status(:ok)
        end

        it '全てのシェフを返却すること' do
          expect(response.parsed_body.length).to eq 2
        end
      end

      context 'キーワードがnullの時' do
        before do
          get '/api/v1/chefs/search', params: { page: 1 }
        end

        it '400 Bad Requestを返却すること' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context '該当するシェフが存在しない時' do
      before do
        create(:user, :with_type_chef, name: '山田太郎')
        create(:user, :with_type_chef, name: '山田花子')
        get '/api/v1/chefs/search', params: { keyword: '山本', page: 1 }
      end

      it '200を返却すること' do
        expect(response).to have_http_status(:ok)
      end

      it 'レスポンスは空の配列を返却すること' do
        expect(response.parsed_body).to eq([])
      end
    end

    context 'ページネーションが適用されるとき' do
      before do
        create_list(:user, 11, :with_type_chef, name: '山田太郎')
      end

      it '1ページ目は最大10件のアイテムを返却すること' do
        get '/api/v1/chefs/search', params: { keyword: '山田', page: 1 }
        expect(response.parsed_body.length).to eq 10
      end

      it '2ページ目が正しい数のアイテムを返却すること' do
        get '/api/v1/chefs/search', params: { keyword: '山田', page: 2 }
        expect(response.parsed_body.length).to eq 1
      end

      it '0がページ番号として与えられたときに200を返却すること' do
        create_list(:user, 11, :with_type_chef, name: '山田太郎')

        get '/api/v1/chefs/search', params: { keyword: '山田', page: 0 }
        expect(response).to have_http_status(:ok)
      end
    end

    context '一般シェフが含まれているとき' do
      before do
        create(:user, :with_type_chef, name: '山田太郎')
        create(:user, user_type: 'user', name: '山田花子')
        get '/api/v1/chefs/search', params: { keyword: '山田', page: 1 }
      end

      it '有名シェフのみ返却されること' do
        expect(response.parsed_body.length).to eq 1
      end

      it '有名シェフが返却されること' do
        expect(response.parsed_body[0]['name']).to eq '山田太郎'
      end
    end
  end
end
