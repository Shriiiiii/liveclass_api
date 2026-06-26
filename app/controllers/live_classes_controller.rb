class LiveClassesController < ApplicationController
  # auntherization runnning frst before doing any action
  before_action :authorize_request
  # running helper method set live class
  before_action :set_live_class, only: [:show, :update, :destroy]

  def index
    logger.info "[INFO] Authorized Request: Fetching all live classes "
    @classes = LiveClass.all
    #simple debug for showing total records
    logger.debug " [DEBUG] DB Metrics - Total Records Loaded: #{@classes.count} "
    render json: @classes, status: :ok 
  end

  # retriving class using id
  def show
    logger.info " [INFO] Fetching details for Classroom ID: #{params[:id]} "
    render json: @class, status: :ok
  end

  #
  def create
    logger.info " [INFO] Processing request to createnew live class "
    @class = LiveClass.new(live_class_params)
    
    if @class.save
      logger.info " [INFO] Success: Live Class '#{@class.subject}' created successfully "
      render json: @class, status: :created
    else
      # if any field is missing ..validation fsilure
      logger.warn " [WARN] Validation Rejected: fields missing or invalid "
      render json: { errors: @class.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing => e
    # if it is a bad json request
    logger.error " [ERROR] Parameters missing the mandatory 'live_class' key "
    render json: { error: "400 Bad Request: #{e.message}" }, status: :bad_request
  end

  def update
    logger.info " [INFO] update operation on Classroom ID: #{params[:id]} "

    debugger

    if @class.update(live_class_params)
      logger.info " [INFO] Update operation completed successfully "
      render json: @class, status: :ok
    else
      logger.warn " [WARN] stopped due to model attribute constrains"
      render json: { errors: @class.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    logger.warn " [WARN] Permanently deleting Classroom ID #{params[:id]} "
    @class.destroy
    head :no_content # Returns 204 No Content 
  end


  private
  # helper method 
  def set_live_class
    @class = LiveClass.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    logger.error " [ERROR] Classroom ID #{params[:id]} not exist "
    render json: { error: "404 Not Found:requested session not found " }, status: :not_found
  end

  # parameters require and permit and handledd unperrmitted data adding
  private

  def live_class_params
    raw_data = params.require(:live_class)
    permitted_data = raw_data.permit(:id, :subject, :trainer, :status, :capacity)

    if raw_data.keys != permitted_data.keys
      logger.warn " [WARN] Security Warning: Attempted to submit non-existent database columns "
    end

    permitted_data
  end
end