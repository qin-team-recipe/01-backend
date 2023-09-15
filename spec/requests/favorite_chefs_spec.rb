require 'rails_helper'

describe 'FavoriteChefs' do
  let!(:user) { create(:user) }
  let!(:chef) { create(:user, :with_type_chef) }
  let!(:other_user) { create(:user) }

  describe 'POST /users/:user_id/favorite_chefs' do
    context 'リクエストが有効な場合' do
      before { post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: chef.id) }

      it 'お気に入りのシェフが追加されること' do
        expect(response).to have_http_status(:ok)
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
  end

  describe 'DELETE /users/:user_id/favorite_chefs/:chef_id' do
    let!(:user) { create(:user) }
    let!(:chef) { create(:user, :with_type_chef) }

    context 'リクエストが有効な場合' do
      before do
        post api_v1_user_favorite_chefs_path(user_id: user.id, chef_id: chef.id)
        delete api_v1_user_favorite_chef_path(user_id: user.id, chef_id: chef.id)
      end

      it 'お気に入りのシェフが削除されること' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'リクエストが無効な場合' do
      before { delete api_v1_user_favorite_chef_path(user_id: user.id, chef_id: chef.id) }

      it 'エラーレスポンスが返されること' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
