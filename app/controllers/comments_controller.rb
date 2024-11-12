class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)


    if @comment.save
      redirect_to prototype_path(@comment.prototype)  # 詳細ページにリダイレクト
    else
      # 保存に失敗した場合の処理（詳細ページに戻る）
      @prototype = @comment.prototype
      @comments = @prototype.comments.includes(:user)  # 詳細ページに必要なインスタンス変数を再設定
      render "prototypes/show" 
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end
