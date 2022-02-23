class Auth
  include Mongoid::Document
  include Mongoid::Timestamps

  HMAC_SECRET = 'my$ecretK3y'

end
