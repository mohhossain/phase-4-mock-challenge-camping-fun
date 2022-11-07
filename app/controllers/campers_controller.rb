class CampersController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

rescue_from ActiveRecord::RecordInvalid, with: :record_not_valid

    def index 
        campers = Camper.all
        render json: campers, each_serializer: CamperWithoutActivitiesSerializer
    end

    def show 
        camper = Camper.find(params[:id])
        render json: camper, status: :ok
    end

    def create 
        camper = Camper.create!(camper_params)
        # render json: camper.to_json(only: [:id, :name, :age]), status: :created

        render json: camper, status: :created, serializer: CamperWithoutActivitiesSerializer

    end

    private

    def record_not_found
        render json: {
            "error": "Camper not found"
        }, status: :not_found
    end

    def record_not_valid(error)
        render json: { "errors": error.record.errors.full_messages }, status: :unprocessable_entity
    end

    def camper_params
        params.permit(:name, :age)
    end

end
