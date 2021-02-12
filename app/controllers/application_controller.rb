class ApplicationController < ActionController::API
  protected

  def process_outcome(outcome)
    return render json: outcome.errors.details, status: :bad_request unless outcome.valid?

    block_given? ? yield(outcome.result) : head(:no_content)
  end
end
