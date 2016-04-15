require 'application_smser'

class UserSMSer < ApplicationSMSer
  def self.phone_number_verification_instructions(user)
    message = I18n.t('smser.phone_number_verification_instructions.message',
      code: user.phone_number_verification_token
    )
    sms(to: user.phone_number, message: message)
  end
end
