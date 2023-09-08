require 'rails_helper'

RSpec.describe 'CartLists' do
  describe 'GET /cart_lists' do
    context 'レシピのレコードがあるとき' do
      let(:cart_list) { create(:cart_list, :with_user_and_recipe) }
      let!(:cart_item) { create(:cart_item, cart_list:) }

      it '200を返却すること' do
        get api_v1_user_cart_lists_path(cart_list.user_id)
        expect(response).to have_http_status(:ok)
      end

      it 'レスポンスの中身は1件のみであること' do
        get api_v1_user_cart_lists_path(cart_list.user_id)
        expect(response.parsed_body['lists'].length).to eq 2
      end

      it 'listsのレコードを返却すること' do
        get api_v1_user_cart_lists_path(cart_list.user_id)

        expect(response.parsed_body).to include(
          'lists' => contain_exactly(
            hash_including(
              'name' => 'じぶんメモ',
              'own_notes' => true,
              'position' => 1
            ),
            hash_including(
              'id' => cart_list.id,
              'recipe_id' => cart_list.recipe_id,
              'name' => cart_list.name,
              'own_notes' => cart_list.own_notes,
              'position' => cart_list.position,
              'items' => contain_exactly(
                hash_including(
                  'name' => cart_item.name,
                  'is_checked' => cart_item.is_checked,
                  'position' => cart_item.position,
                  'created_at' => cart_item.created_at.iso8601(3),
                  'updated_at' => cart_item.updated_at.iso8601(3)
                )
              )
            )
          )
        )
      end
    end
  end
end
