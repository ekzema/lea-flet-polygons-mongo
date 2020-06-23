class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def render_success_response(data = nil, status = :ok)
    render json: {
        success: true,
        data: data
    }, status: status
  end

  def render_error_response(message = 'Bad Request', status = :bad_request)
    render json: {
        success: false,
        message: message,
        data: nil
    }, status: status
  end
end
