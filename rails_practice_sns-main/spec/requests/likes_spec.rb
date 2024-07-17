require "rails_helper"

RSpec.describe "Likes", type: :request do
    let(:headers) { { ContentType: "application/json" } }

    describe "POST /likes/:post_id/create" do
        let!(:user_1) { create :user, name: "テスト君", email: "test@test.com", password: "test" }
        let!(:post_1) { create :post, user_id: user_1.id, content: "投稿1" }
        subject { post "/likes/#{post_1.id}/create", headers: headers }
        context "正常系" do
            # ログイン処理
            before do
                post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
            end
            
            it "いいねした投稿画面にリダイレクトする" do
                subject
                expect(response.status).to eq 302
                expect(response.body).to include("#{ request.host }/posts/#{ post_1.id }")
            end

            it "いいねが作成されている" do
                subject
                expect(Like.find_by(user_id: user_1.id, post_id: post_1.id).present?).to be_truthy
            end
        end
    end 
end    