class ShoppingListMailer < ApplicationMailer
  default from: "stevendjie1@gmail.com"

  def shopping_list_mail(email, content)
    mail(to: email, subject: "Your Shopping List", body: content)
  end
end