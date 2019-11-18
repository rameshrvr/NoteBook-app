class ShareNote < ApplicationRecord
	belongs_to :note
	belongs_to :user_profile
end
