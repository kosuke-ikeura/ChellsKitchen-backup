# frozen_string_literal: true

class FlavorMailer < ApplicationMailer
  def send_status_1(user_ids, flavor_ids)
    flavors_1 = Flavor.where(id: flavor_ids)
    @flavors_message = flavors_1.map(&:name).join(' ')
    @users = User.where(id: user_ids)
    mail(from: 'ikoke326@gmail.com', to: @users.pluck(:email), subject: "#{@flavors_message}が不足しています！")
  end
end
