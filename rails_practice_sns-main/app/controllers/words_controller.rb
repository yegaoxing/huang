class WordsController < ApplicationController

  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    # whereで取る場合は下記のコード
    # @words = Word.where(user_id: @current_user.id)

    # アソシエーションで取る場合は下記のコード
    @words = @current_user.words
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(
      user_id: @current_user.id,
      word: params[:word],
      reading: params[:reading],
    )
    if @word.save
      flash[:notice] = "作成しました"
      redirect_to("/words")
    else
      render :new
    end
  end

  def show
    @word = Word.find_by(id: params[:id])
  end

  def edit
    @word = Word.find_by(id: params[:id])

  end

  def update
    @word = Word.find_by(id: params[:id])
    @word.word = params[:word]
    @word.reading = params[:reading]

    if @word.save
        redirect_to("/words")
        flash[:notice] = "編集しました"
      else
        render :edit
    end

  end

  def destroy
    ### ensure_correct_userがbefore_actionで必ず実行される
    ### @wordはクラス変数でメソッドのスコープを越えて参照できるから、このメソッドで『 @word = Word.find_by(id: params[:id]) 』は必要ない
    ### 更にいうとensure_correct_userで@wordを取得する方法も、アソシエーションを使えばもっと綺麗に書ける
    ### @word = Word.find_by(id: params[:id])  => Word全体に対してparamsのidで検索して、それが@current_userのものか見ている
    ### @word = @current_user.words.find_by(id: params[:id])  => 検索範囲がそもそも@current_user.wordなので、このユーザーのword以外のidが渡されてもnilが返る
    @word = Word.find_by(id: params[:id])
    @word.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/words")
  end

  def ensure_correct_user
    @word = Word.find_by(id: params[:id])
    if @word.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/words")
    end
  end

end

#
