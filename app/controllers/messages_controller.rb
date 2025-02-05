class MessagesController < ApplicationController
	 def index
 		 @messages = Message.all
 	end

	 def create
 		 @message = Message.new(content: params[:content])
 		 @message.user_id = current_user.id
 		 @message.save
 	end
end
