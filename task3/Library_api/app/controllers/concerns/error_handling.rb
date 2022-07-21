module ErrorHandling
  extend ActiveSupport::Concern
  included do

    rescue_from ActiveRecord::RecordNotFound,with: :notfound

    private

    def notfound(exception)
      render json: exception.message, status: 404
    end
  end

end
