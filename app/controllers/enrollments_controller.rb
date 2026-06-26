class EnrollmentsController < ApplicationController
  before_action :authorize_request

  # GET /enrollments
  def index
    # Using the Active Record relationship to pull only this student's classes
    my_enrolled_classes = @current_user.live_classes

    logger.info " [INFO] Student '#{@current_user.username}' is fetching their personal schedule "
    render json: my_enrolled_classes, status: :ok
  end

  def create
    # check if class exists
    live_class = LiveClass.find_by(id: params[:live_class_id])
    if live_class == nil
      return render json: { error: "Class not found" }, status: :not_found
    end

    # check if admin or trainer is trying to attend
    if @current_user.trainer? || @current_user.admin?
      logger.warn " [WARN] Security Warning: Admin/Trainer '#{@current_user.username}' blocked from attending a class "
      return render json: { error: "403 Forbidden: Only Students are allowed to attend classes" }, status: :forbidden
    end

    # check if class status completed
    if live_class.status == "Completed"
      logger.warn " [WARN] Registration Blocked: Class is already completed "
      return render json: { error: "422 Unprocessable Entity: This class has already finished" }, status: :unprocessable_entity
    end

    # check if capacity full
    if live_class.capacity.to_i <= 0
      logger.warn " [WARN]  Classroom id full "
      return render json: { error: "422 Unprocessable Entity: No seats " }, status: :unprocessable_entity
    end

    enrollment = Enrollment.new(user_id: @current_user.id, live_class_id: live_class.id)

    if enrollment.save
      # decrement capacity after successful checkin
      live_class.decrement!(:capacity)

      logger.info " [INFO] Success: Student '#{@current_user.username}' checked into Class '#{live_class.subject}' "
      render json: { message: "Successfully checked into the live class!" }, status: :created
    else
      render json: { errors: enrollment.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
