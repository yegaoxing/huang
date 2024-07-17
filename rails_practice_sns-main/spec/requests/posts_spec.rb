require "rails_helper"
require 'securerandom'

RSpec.describe "Posts", type: :request do
    let(:headers) { { ContentType: "application/json" } }

    describe "GET posts(投稿一覧)" do
        subject { get posts_path, headers: headers }
        let!(:user_1) { create :user, name: "テスト君", email: "test@test.com", password: "test" }
        let!(:post_1) { create :post, user_id: user_1.id, content: "投稿1" }
        let!(:post_2) { create :post, user_id: user_1.id, content: "投稿2" }
        let!(:post_3) { create :post, user_id: user_1.id, content: "投稿3" }

        context "正常系" do
            # ログイン処理
            before do
                post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
            end
            it "リクエストが成功する" do
                subject
                expect(response.status).to eq 200
            end

            it "投稿一覧が取得出来ている" do
                subject
                expect(response.body).to include("投稿1")
                expect(response.body).to include("投稿2")
                expect(response.body).to include("投稿3")
            end
        end

        context "異常系" do
            it "ログインしていない場合ログインページにリダイレクトする" do
                subject
                expect(response.status).to eq 302
                expect(response.body).to include("/login")
            end
        end
    end
    describe "POST /posts/:id (投稿作成)" do
        subject { post posts_path, headers: headers, params: params }

        let!(:user_1) { create :user, name: "テスト君", email: "test@test.com", password: "test" }  
        let(:params) { { content: content } }

        context '正常系' do
            let(:content) { "テスト本文" }
            before do
                post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
            end

            it "リクエストが成功する" do
                subject
                expect(response.status).to eq 302
                expect(response).to redirect_to("http://www.example.com/posts")
            end

            it "投稿が作成されている" do
                subject
                expect(Post.find_by(user_id: user_1.id).present?).to be_truthy
            end
        end

        context '異常系' do
            # ログイン処理
            before do
                post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
            end
            context "140字以上の場合" do
                let(:content) { SecureRandom.alphanumeric(141) } 

                it "リクエストが成功する" do
                    subject
                    expect(response.status).to eq 200
                    expect(response.body).to include(params[:content])
                end

                it "投稿が作成されていない" do
                    expect do
                        subject
                    end.to change(Post, :count).by 0
                end

                it "エラーの文章が返っている" do
                    subject
                    expect(response.body).to include(I18n.t("errors.messages.too_long", count: 140))
                end
            end  

            context '本文が入力されていない場合' do
                let(:content) { "" }           
                
                it "リクエストが成功する" do
                    subject
                    expect(response.status).to eq 200
                    expect(response.body).to include(params[:content])
                end

                it "投稿が作成されていない" do
                    expect do
                        subject
                    end.to change(Post, :count).by 0
                end

                it "エラーの文章が返っている" do
                    subject
                    error_message = "#{ Post.human_attribute_name(:content) }#{ I18n.t("errors.messages.blank") }"
                    expect(response.body).to include(error_message)
                end
            end
        end
    end

    describe "PATCH /posts/:id (投稿編集)" do
        subject { patch post_path(post_1), headers: headers, params: params }

        let!(:user_1) { create :user, name: "テスト君", email: "test@test.com", password: "test" }  
        let!(:post_1) { create :post, user_id: user_1.id, content: "編集前本文" }
        let(:params) { { content: content } }

        context "正常系" do
            let(:content) { "編集後本文" }
            # ログイン処理
            before do
                post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
            end
            it "リクエストが成功する" do
                subject
                expect(response.status).to eq 302
                expect(response).to redirect_to("http://www.example.com/posts")
            end

            it "投稿が編集されている" do
                subject
                # expect(post_1.reload.content).to eq params[:content]
                expect(Post.find_by(id: post_1.id).content).to eq params[:content]
            end
        end

        context '異常系' do
            # ログイン処理
            before do
                post login_path, headers: headers, params: { email: user_1.email, password: user_1.password }
            end
            context "140字以上の場合" do
                let(:content) { SecureRandom.alphanumeric(141) } 

                it "リクエストが成功する" do
                    subject
                    expect(response.status).to eq 200
                    expect(response.body).to include(params[:content])
                end

                it "投稿が編集されていない" do
                    subject
                    expect(Post.find_by(id: post_1.id).content).to_not eq params[:content]
                end

                it "エラーの文章が返っている" do
                    subject
                    expect(response.body).to include(I18n.t("errors.messages.too_long", count: 140))
                end
            end  

            context '本文が入力されていない場合' do
                let(:content) { "" }           
                
                it "リクエストが成功する" do
                    subject
                    expect(response.status).to eq 200
                    expect(response.body).to include(params[:content])
                end

                it "投稿が編集されていない" do
                    subject
                    expect(Post.find_by(id: post_1.id).content).to_not eq params[:content]
                end

                it "エラーの文章が返っている" do
                    subject
                    error_message = "#{ Post.human_attribute_name(:content) }#{ I18n.t("errors.messages.blank") }"
                    expect(response.body).to include(error_message)
                end
            end
        end
    end
end
