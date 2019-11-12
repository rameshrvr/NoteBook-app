# Preview all emails at http://localhost:3000/rails/mailers/notes_mailer
class NotesMailerPreview < ActionMailer::Preview

	def signup_email
		user_details = UserProfile.new(
			name: 'Ramesh', email: 'ramesh@test.com'
		)

		NotesMailer.with(user: user_details).signup_email
	end

	def send_notes_to_user
		user_details = UserProfile.new(
			name: 'Ramesh', email: 'ramesh@test.com'
		)
		note_details = Note.new(
			title: 'Test title', description: 'test description'
		)

		NotesMailer.with(user: user_details, notes: note_details).send_notes_to_user
	end
end
