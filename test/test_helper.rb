ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, options = {})
    options_default = { password: 'password', remember_me: '1' }
    options.reverse_merge!(options_default)
    post login_path, params: { session: {
      email: user.email, password: options[:password], remember_me: options[:remember_me] } }
  end
end
