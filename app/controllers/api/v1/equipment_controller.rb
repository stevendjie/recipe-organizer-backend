module Api
  module V1
    class EquipmentController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_equipment, only: [:show, :update, :destroy]
    
      # GET /equipment
      def index
        @equipment = Equipment.all
    
        render json: @equipment
      end
    
      # GET /equipment/1
      def show
        render json: @equipment
      end
    
      # POST /equipment
      def create
        @equipment = Equipment.new(equipment_params)
    
        if @equipment.save
          render json: @equipment, status: :created, location: @equipment
        else
          render json: @equipment.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /equipment/1
      def update
        if @equipment.update(equipment_params)
          render json: @equipment
        else
          render json: @equipment.errors, status: :unprocessable_entity
        end
      end
    
      # DELETE /equipment/1
      def destroy
        @equipment.destroy
      end
    
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_equipment
          @equipment = Equipment.find(params[:id])
        end
    
        # Only allow a trusted parameter "white list" through.
        def equipment_params
          params.fetch(:equipment, {})
        end
    end    
  end
end