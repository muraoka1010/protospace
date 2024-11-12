class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_user_signed_in, only: :edit
  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path, notice: "投稿が完了しました"
    else
      render :new  # 失敗した場合はnewページを再描画
    end

  end

  def show
    @prototype = Prototype.find_by(id: params[:id])
  if @prototype.nil?
    redirect_to root_path, alert: "Prototype not found"
  else
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id]) # パスパラメータから対象のプロトタイプを取得

    if @prototype.update(prototype_params) # 更新に成功した場合
      redirect_to prototype_path(@prototype), notice: 'プロトタイプが更新されました。'
    else
      render :edit # 更新に失敗した場合、編集ページを再表示
    end
  end

  def destroy

    @prototype = Prototype.find(params[:id])

    @prototype.destroy
    redirect_to root_path
  end


  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def check_user_signed_in
    unless user_signed_in?
      redirect_to root_path
    end
  end

end
