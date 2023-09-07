module Api::ExceptionHandler
  extend ActiveSupport::Concern

  # NOTE: 優先度が高いものを下から順に並べる
  included do
    rescue_from StandardError, with: :render_500
    rescue_from ActiveRecord::RecordInvalid, with: :render_422
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    # rescue_from XXX, with: :render_403 # 認可処理を実装したら対応する
    rescue_from ActionController::ParameterMissing, with: :render_400
    rescue_from ActionController::BadRequest, with: :render_400
  end

  private

  def render_400
    render_error(400, 'Bad Request')
  end

  def render_404
    render_error(404, 'Record Not Found')
  end

  def render_422(exception)
    extra_fields = {
      details: exception.record.errors.details,
      messages: exception.record.errors.full_messages
    }
    render_error(422, 'Unprocessable Entity', extra_fields)
  end

  def render_500(exception)
    Rails.logger.error exception # ログ出力
    render_error(500, exception)
  end

  def render_error(status, message, extra_fields = {})
    response = {
      status:,
      message:
    }.merge(extra_fields)

    render json: response, status:
  end
end
