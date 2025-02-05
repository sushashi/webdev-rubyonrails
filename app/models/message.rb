class Message < ApplicationRecord
	 belongs_to :user, touch: true

	 validates :user_id, presence: true
	 validates :content, presence: true

	 default_scope { order(created_at: :desc) }

	 after_create_commit do
 		 broadcast_prepend_to "messages", partial: "messages/message_row", target: "messages_list"
 	end
end
