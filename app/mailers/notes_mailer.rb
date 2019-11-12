class NotesMailer < ApplicationMailer

	def signup_email
		@user = params[:user]
		@url = 'tcp://127.0.0.1:3000'
		mail(to: @user.email, subject: 'Your email Successfully registered with Notes App')
	end

	def send_notes_to_user
		@notes = params[:notes]
		@user = params[:user]
		mail(to: @user.email, subject: 'Plese find the notes you requested')
	end
end
