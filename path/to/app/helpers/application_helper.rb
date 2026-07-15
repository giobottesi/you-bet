# app/helpers/application_helper.rb

module ApplicationHelper
  def translate(key)
    I18n.t(key)
  end
end