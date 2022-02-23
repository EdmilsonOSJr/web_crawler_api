class AuthsController < ApplicationController

    def create 

        # The secret must be a string. A JWT::DecodeError will be raised if it isn't provided.
        payload = { name: params[:name]}
        token = JWT.encode payload, Auth::HMAC_SECRET, 'HS256'

        render json: { token: token }

    end

end
