class BasicAuthRoutes < Grape::API
  class AuthenticationError < Ant::Exceptions::AntFail
    def initialize
      super('Unauthorized. Please provide proper keys')
    end

    def http_code
      401
    end
  end

  module AuthHelper
    def current_user!
      token = env['HTTP_AUTHORIZATION']
      raise(AuthenticationError) unless token && /^Basic .*/.match(token)
      data = token.tr('Basic ', '')
      user, pass = Base64.decode64(data).split(':')
      raise(AuthenticationError) unless user == 'test' && pass == 'secret'
      user
    end
  end

  namespace :secret do
    get do
      user = current_user!
      { money: 1000, user: user }
    end
  end
end
