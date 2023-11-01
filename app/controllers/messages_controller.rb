class MessagesController < ApplicationController
  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
    @messages = Message.includes(:user)
  end
  def create
    # カレントルームのレコードを取得
    @room = Room.find(params[:room_id])
    # カレントルームと紐づいたメッセージレコードを代入保存
    if @room.messages.create(message_params)
      redirect_to room_messages_path(@room)
    else
      # renderで再出力を行う際に@messagesのデータは送信ボタンを押した際に失われているため再度ビューへ渡す
      @messages = Message.includes(:user)
      render :index, status: :unprocessable_entity
    end
  end
  private

  def message_params
    params.require(:message).permit(:content).merge(user_id:current_user.id)
  end

end
