require 'rails_helper'

RSpec.describe 'FavoriteChefs' do
  describe 'POST /users/:user_id/favorite_chefs' do
    let!(:user) { create(:user) }
    let!(:chef) { create(:user, :with_type_chef) }
    let!(:other_user) { create(:user) }

    context 'リクエストが有効な場合' do
      it '200を返却すること' do
        post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: chef.id)
        expect(response).to have_http_status(:ok)
      end

      it 'お気に入りのシェフがデータベースに追加されること' do
        expect { post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: chef.id) }
          .to change(Relationship, :count).by(1)
      end

      it 'お気に入りしたシェフのレコードを返却すること' do
        post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: chef.id)

        expect(response.parsed_body).to include({
                                                  'status' => 'success',
                                                  'message' => 'フォローしました',
                                                  'user_id' => user.id,
                                                  'chef_id' => chef.id
                                                })
      end
    end

    context 'リクエストが無効な場合' do
      before do
        post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: chef.id)
        post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: chef.id)
      end

      it 'エラーレスポンスが返されること' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '自身をフォローしようとした場合' do
      before { post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: user.id) }

      it 'エラーレスポンスが返されること' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '一般シェフをフォローしようとした場合' do
      before { post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: other_user.id) }

      it 'エラーレスポンスが返されること' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '存在しないuser_idでのリクエスト' do
      before { post api_v1_user_favorite_chefs_path(user_id: 'nonexistent', chef_id: chef.id) }

      it 'エラーレスポンスが返されること' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context '存在しないchef_idでのリクエスト' do
      before { post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: 'nonexistent') }

      it 'エラーレスポンスが返されること' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /users/:user_id/favorite_chefs/:chef_id' do
    let!(:user) { create(:user) }
    let!(:chef) { create(:user, :with_type_chef) }

    context 'リクエストが有効な場合' do
      before do
        post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: chef.id)
      end

      it 'フォローがデータベースに正常に作成されること' do
        expect(Relationship.count).to eq(1)
      end

      it '200を返却すること' do
        expect(response).to have_http_status(:ok)
      end

      describe 'フォローの削除' do
        before do
          delete api_v1_user_favorite_chef_path(user_id: user.id, chef_id: chef.id)
        end

        it '200を返却すること' do
          expect(response).to have_http_status(:ok)
        end

        it 'お気に入りのシェフがデータベースから削除されること' do
          expect(Relationship.count).to eq(0)
        end
      end
    end

    context 'リクエストが無効な場合' do
      before { delete api_v1_user_favorite_chef_path(user_id: user.id, chef_id: chef.id) }

      it 'エラーレスポンスが返されること' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '存在しないuser_idでのリクエスト' do
      before do
        delete api_v1_user_favorite_chef_path(user_id: 'nonexistent', chef_id: chef.id)
      end

      it 'エラーレスポンスが返されること' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context '存在しないchef_idでのリクエスト' do
      before do
        delete api_v1_user_favorite_chef_path(user_id: user.id, chef_id: 'nonexistent')
      end

      it 'エラーレスポンスが返されること' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
