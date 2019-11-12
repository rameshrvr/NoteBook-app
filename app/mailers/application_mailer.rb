class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@notesapp.com'
  layout 'mailer'
end
