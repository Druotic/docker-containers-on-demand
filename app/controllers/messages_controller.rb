class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    # render text: params.inspect
    # return
    @group = Group.find(params[:group_id])
    @messages = Message.where(group: @group)
  end

  def show
    respond_with(@message)
  end

  def new
    @group = Group.find(params[:group_id])
    @message = Message.new
  end

  def edit
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.find(message_params[:group_id])
    @message = Message.new(message_params)
    @message.group = @group
    @message.user = current_user
    if @message.save
      flash[:success] = "Message saved"
    else
      flash[:failure] = "Message could not be saved"
    end
    redirect_to messages_path(group_id: @group.id)
  end

  def update
    @message.update(message_params)
    respond_with(@message)
  end

  def destroy
    @message.destroy
    respond_with(@message)
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:content, :group_id)
    end
end
