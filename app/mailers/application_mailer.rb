# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'suke',
          bcc: 'ikoke326@gmail.com',
          reply_to: 'ikoke326@gmail.com'
  layout 'mailer'
end
