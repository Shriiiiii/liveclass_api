class JsonWebToken
  # Grab the secret key unique to your Rails application for signing tokens
  SECRET_KEY = Rails.application.secret_key_base

  # 1. ENCODE: Turn user data into a long secure string string
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end


  # 2. DECODE: Read the secure string back into raw data
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil # Returns nil if someone tampers with the token or if it expires
  end
end
