require 'rails_helper'
require 'securerandom'

RSpec.describe "Words", type: :request do
  let(:headers) { { ContentType: "application/json" } }

  describe "GET /index(単語一覧)" do
    subject { get words_path, headers: headers }
    let!(:user_1) { create :user, name: "テストさん", email: "test@test.com", password: "test"}
    let!(:user_2) { create :user, name: "テストくん", email: "test@test2.com", password: "test"}
    let!(:word_1) { create :word, user_id: user_1.id, word: "単語1", reading: "読み1" }
    let!(:word_2) { create :word, user_id: user_1.id, word: "単語2", reading: "読み2" }
    let!(:word_3) { create :word, user_id: user_1.id, word: "単語3", reading: "読み3" }
    let!(:word_4) { create :word, user_id: user_2.id, word: "単語4", reading: "読み4" }

    context "正常系" do
      #ログイン
      before do
        post login_path, headers: headers, params: {email: user_1.email, password: user_1.password}
      end
      it "リクエストが成功する" do
        get words_path, headers: headers 
        expect(response.status).to eq 200
      end

      it "単語一覧が取得出来ている" do
        subject
        # 登録済みの単語が取得出来ている
        expect(response.body).to include(word_1.word)
        expect(response.body).to include(word_2.word)
        expect(response.body).to include(word_3.word)

        # 登録済みの読みが取得出来ている
        expect(response.body).to include(word_1.reading)
        expect(response.body).to include(word_2.reading)
        expect(response.body).to include(word_3.reading)
      end

      it "他のユーザーの単語が取得できていない" do
        subject
        expect(response.body).not_to include(word_4.word)
        expect(response.body).not_to include(word_4.reading)
      end

    end
  end

  describe "POST /words/:id (単語作成)" do
    subject { post words_path, headers: headers, params: params }
    let!(:user_1) { create :user, name: "テストさん", email: "test@test.com", password: "test"}
    let(:params) { { word: word, reading: reading } }
    
    
    context "正常系" do
      let(:word) { "単語" }
      let(:reading) { "読み" }

      #ログイン処理
      before do
        post login_path, headers: headers, params: {email: user_1.email, password: user_1.password}
      end
      it "リクエストが成功する" do
        subject
        expect(response.status).to eq 302
        expect(response).to redirect_to("http://www.example.com/words")
      end

      it "単語が作成される" do
        subject
        expected_word = Word.find_by(user_id: user_1.id, word: word, reading: reading)
        expect(expected_word.present?).to  be_truthy
        expect(expected_word.word).to eq word
        expect(expected_word.reading).to eq reading
    
      end
    end

    context "異常系" do
      #ログイン処理
      before do
        post login_path, headers: headers, params: {email: user_1.email, password: user_1.password}
      end
      context "単語と読みが空白の場合" do
        let(:word) { "" }
        let(:reading) { "" }

        it "リクエストが成功する" do
          subject
          expect(response.status).to eq 200
          expect(response.body).to include(params[:word])
          expect(response.body).to include(params[:reading])
        end

        it "単語と読みが投稿されない" do
          expect do
            subject
          end.to change(Word, :count).by 0
        end

        it "エラーの文章が返っている" do
          subject
          error_message = "#{ Word.human_attribute_name(:word) }#{ I18n.t("errors.messages.blank") }"
          error_message2 = "#{ Word.human_attribute_name(:reading) }#{ I18n.t("errors.messages.blank") }"
          expect(response.body).to include(error_message)
          expect(response.body).to include(error_message2)
        end
      end

      context "単語と読みが140字以上の場合" do
        let(:word) { SecureRandom.alphanumeric(141) } 
        let(:reading) { SecureRandom.alphanumeric(141) }

        it "リクエストが成功する" do
          subject
          expect(response.status).to eq 200
          expect(response.body).to include(params[:word])
          expect(response.body).to include(params[:reading])
        end

        it "単語と読みが投稿されない" do
          expect do
            subject
          end.to change(Word, :count).by 0
        end

        it "エラーの文章が返っている" do
          subject
          expect(response.body).to include(I18n.t("errors.messages.too_long", count: 140))
        end
      end
    end
  end

  describe "PATCH /words/:id (単語編集)" do
    subject { patch word_path(word_1), headers: headers, params: params }

    let!(:user_1) { create :user, name: "テストさん", email: "test@test.com", password: "test"}
    let!(:user_2) { create :user, name: "テストくん", email: "test@test2.com", password: "test"}
    let!(:word_1) { create :word, user_id: user_1.id, word: "編集前単語", reading: "編集前読み" }
    let!(:word_2) { create :word, user_id: user_2.id, word: "単語4", reading: "読み4" }
    let(:params) { { word: word, reading: reading } }


    context "正常系" do
      let(:word) {"編集後単語"}
      let(:reading) {"編集後読み"}

      # ログイン処理
      before do
        post login_path, headers: headers, params: {email: user_1.email, password: user_1.password}
      end
      it "リクエストが成功する" do
        subject
        expect(response.status).to eq 302
        expect(response).to redirect_to("http://www.example.com/words")
      end

      it "単語と読みが編集されている" do
        subject
        expect(Word.find_by(id: word_1.id).word).to eq params[:word]
        expect(Word.find_by(id: word_1.id).reading).to eq params[:reading]
      end
    end

    context "異常系" do
      # ログイン処理
      before do
        post login_path, headers: headers, params: {email: user_1.email, password: user_1.password}
        
      end

      context "他のユーザーの単語と読みを編集しようとした場合" do
        let(:word) { "単語" }
        let(:reading) { "読み" }

        it "単語と読みが編集されない" do
          subject
          expect(Word.find_by(id: word_2.id).word).to_not eq params[:word]
          expect(Word.find_by(id: word_2.id).word).to_not eq params[:reading]
        end
      end

      context "単語と読みが空白の場合" do
        let(:word) { "" }
        let(:reading) { "" }

        it "リクエストが成功する" do
          subject
          expect(response.status).to eq 200
          expect(response.body).to include(params[:word])
          expect(response.body).to include(params[:reading])
        end

        it "単語と読みが編集されない" do
          subject
          expect(Word.find_by(id: word_1.id).word).to_not eq params[:word]
          expect(Word.find_by(id: word_1.id).reading).to_not eq params[:reading]
        end

        it "エラーの文章が返っている" do
          subject
          error_message = "#{ Word.human_attribute_name(:word) }#{ I18n.t("errors.messages.blank") }"
          error_message2 = "#{ Word.human_attribute_name(:reading) }#{ I18n.t("errors.messages.blank") }"
          expect(response.body).to include(error_message)
          expect(response.body).to include(error_message2)
        end
      end

      context "単語と読みが140字以上の場合" do
        let(:word) { SecureRandom.alphanumeric(141) } 
        let(:reading) { SecureRandom.alphanumeric(141) }
        
        it "リクエストが成功する" do
          subject
          expect(response.status).to eq 200
          expect(response.body).to include(params[:word])
          expect(response.body).to include(params[:reading])
        end

        it "単語と読みが編集されない" do
          subject
          expect(Word.find_by(id: word_1.id).word).to_not eq params[:word]
          expect(Word.find_by(id: word_1.id).reading).to_not eq params[:reading]
        end

        it "エラーの文章が返っている" do
          subject
          expect(response.body).to include(I18n.t("errors.messages.too_long", count: 140))
        end
      end
    end
  end

  describe "DELETE /words/:id (単語削除)" do
    ### paramsが設定されていてsubjectを実行できていなかった 234行からのスコープにparamsが定義されていない
    ### 今回の削除に関してはurlに削除するwordのidを渡すのでparamsは使っていない
    ### urlに入れるパラメータ: クエリパラメータ => word_path(word_1) => word_1をurlで渡している
    ### params: リクエストボディ => urlに含まれない
    subject { delete word_path(word_1), headers: headers }

    let!(:user_1) { create :user, name: "テストさん", email: "test@test.com", password: "test"} 
    let!(:user_2) { create :user, name: "テストくん", email: "test@test2.com", password: "test2"}
    let!(:word_1) { create :word, user_id: user_1.id, word: "削除前単語", reading: "削除前読み" }

    context "正常系" do
      before do
        post login_path, headers: headers, params: {email: user_1.email, password: user_1.password}
      end

      it "リクエストが成功する" do
        subject ### ここのsubjectがなかったからそもそもAPIを実行していなかった
        expect(response.status).to eq 302
        # 単語一覧にリダイレクトする
        expect(response).to redirect_to("http://www.example.com/words")
      end

      it "単語が削除されている" do
        subject
        expect(Word.find_by(id: word_1.id).present?).to be_falsey
      end
    end

    context '異常系' do
      let!(:word_2) { create :word, user_id: user_2.id, word: "削除前単語", reading: "削除前読み" }
      subject { delete word_path(word_2), headers: headers }
      before do
        post login_path, headers: headers, params: {email: user_1.email, password: user_1.password}
      end

      it "削除されていない" do
        subject
        expect(Word.find_by(id: word_2.id).present?).to be_truthy
      end
    end
  end
end