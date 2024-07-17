require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:headers) { { ContentType: "application/json" } }

  describe "POST /follows/:user_id (ユーザーをフォローする)" do
    subject { post "/follows/#{ user_2.id }", headers: headers} 

    let!(:user_1) { create :user, name: "フォローするUser", email: "test1@test.com", password: "test1" }
    let!(:user_2) { create :user, name: "フォローされるUser", email: "test2@test.com", password: "test2" }

    before do
      post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
    end

    context "正常系" do
      it "リクエストが成功する" do
        subject
        # expect(response.status).to eq 200 にしたいけど一覧がないので204で返している
        expect(response.status).to eq 204
        expect(Follow.find_by(follow_user_id: user_1.id, followed_user_id: user_2.id).present?).to be_truthy
      end
    end
  end

  describe "GET /follows (フォロー一覧)" do
    subject { get "/follows", headers: headers}

    let!(:user_1) { create :user, name: "User1", email: "test1@test.com", password: "test1" }
    let!(:user_2) { create :user, name: "User2", email: "test2@test.com", password: "test2" }
    let!(:user_3) { create :user, name: "User3", email: "test3@test.com", password: "test3" }
    let!(:user_4) { create :user, name: "User4", email: "test4@test.com", password: "test4" }
    let!(:user_5) { create :user, name: "User5", email: "test5@test.com", password: "test5" }

    let!(:follow_1) { create :follow, follow_user_id: user_1.id, followed_user_id: user_2.id }
    let!(:follow_2) { create :follow, follow_user_id: user_1.id, followed_user_id: user_3.id }
    let!(:follow_3) { create :follow, follow_user_id: user_1.id, followed_user_id: user_4.id }

    let(:params) { { followed_user_id: followed_user_id } }

    before do
      post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
    end

    context "正常系" do
      it "リクエストが成功する" do
        subject
        expect(response.status).to eq 200
      end

      it "フォロー一覧が取得出来ている" do
        subject
        expect(response.body).to include(user_2.name)
        expect(response.body).to include(user_3.name)
        expect(response.body).to include(user_4.name)
      end

      it "フォローではない人が表示されない" do
        expect(response.body).not_to include(user_5.name)
      end
    end

    context "フォローが居ない場合(空配列)" do
      let(:followed_user_id) { [] }

      before do
        post login_path, headers: headers, params: { email: user_5.email, password: user_5.password }
      end

      it "空配列をループさせていない" do
        subject
        expect(response.body).not_to eq params[:followed_user_id]
      end
    end

    context "フォローが居ない場合(nil)" do
      let(:followed_user_id) { nil }

      before do
        post login_path, headers: headers, params: { email: user_5.email, password: user_5.password }
      end

      it "nilをループさせていない" do
        subject
        expect(response.body).not_to eq params[:followed_user_id]
      end

    end

  end

  describe "GET /followers (フォロワー一覧)" do
    subject { get "/followers", headers: headers }
    let!(:user_1) { create :user, name: "User1", email: "test1@test.com", password: "test1" }
    let!(:user_2) { create :user, name: "User2", email: "test2@test.com", password: "test2" }
    let!(:user_3) { create :user, name: "User3", email: "test3@test.com", password: "test3" }
    let!(:user_4) { create :user, name: "User4", email: "test4@test.com", password: "test4" }
    let!(:user_5) { create :user, name: "User5", email: "test5@test.com", password: "test5" }

    let!(:follower_1) { create :follow, followed_user_id: user_1.id, follow_user_id: user_2.id }
    let!(:follower_2) { create :follow, followed_user_id: user_1.id, follow_user_id: user_3.id }
    let!(:follower_3) { create :follow, followed_user_id: user_1.id, follow_user_id: user_4.id }

    let(:params) { {follow_user_id: follow_user_id } }

    before do
      post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
    end

    context "正常系" do
      it "リクエストが成功する" do
        subject
        expect(response.status).to eq 200
      end

      it "フォロワー一覧が取得出来ている" do
        subject
        # 文字列にしてゴリ押しになってる気がする
        # expect(response.body).to include("User2")
        # expect(response.body).to include("User3")
        # expect(response.body).to include("User4")

        ### 上にuser_2~5を定義しているから『user_2.name』みたいにするとゴリ押しじゃなくなる
        expect(response.body).to include(user_2.name)
        expect(response.body).to include(user_3.name)
        expect(response.body).to include(user_4.name)
      end

      it "フォロワーではない人が表示されない" do
        subject
        # :72 と同じでゴリ押しになっている気がする
        # expect(response.body).not_to include("User5")

        ### :72と同じ
        expect(response.body).not_to include(user_5.name)
      end
    end
    
    context "フォロワーが居ない場合(空配列)" do
      let(:follow_user_id) { [] }


      before do
        post login_path, headers: headers, params: { email: user_5.email, password: user_5.password }
      end

      it "空配列をループさせていない" do
        subject
        expect(response.body).not_to eq params[:followed_user_id]
      end
    end

    context "フォロワーが居ない場合(nil)" do
      let(:follow_user_id) { nil }

      before do
        post login_path, headers: headers, params: { email: user_5.email, password: user_5.password }
      end

      it "nilをループさせていない" do
        subject
        expect(response.body).not_to eq params[:followed_user_id]
      end
    end
  end

  describe "POST /follows/:user_id/destroy (フォローを解除する)" do
    subject { post "/follows/#{ user_2.id }/destroy", headers: headers }

    let!(:user_1) { create :user, name: "フォローしているUser", email: "test1@test.com", password: "test1" }
    let!(:user_2) { create :user, name: "フォローされているUser", email: "test2@test.com", password: "test2" }

    let!(:follow_1) { create :follow, follow_user_id: user_1.id, followed_user_id: user_2.id }

    before do
      post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
    end

    context "正常系" do
      it "リクエストが成功する" do
        subject
      end

      it "フォロー解除が出来ている" do
        subject
        expect(Follow.find_by(id: follow_1.id).present?).to be_falsey
      end
    end
  end

end
