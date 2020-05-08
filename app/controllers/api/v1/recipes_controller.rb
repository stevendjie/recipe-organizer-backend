module Api
  module V1
    class RecipesController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_recipe, only: [:show, :update, :destroy]
    
      # GET /recipes
      def index
        @recipes = current_user.recipes.all
        render json: @recipes
      end
    
      # GET /recipes/1
      def show
        render json: @recipe
      end
    
      # POST /recipes
      def create
        source_url = recipe_params[:source_url]
        recipe = { title: recipe_params[:title] }
        if source_url.present?
          # TODO: move elsewhere
          base_endpoint = 'https://api.spoonacular.com/recipes'
          api_key = '61da5a0bce374243a421ab56e2b092bc'

          extract_path = '/extract'

          response = Faraday.get(base_endpoint + extract_path, { apiKey: api_key }, { url: source_url })
          if response.status == 200
            
          end
        end

        @recipe = current_user.recipes.build(recipe)

        if @recipe.save
          render json: @recipe.to_json(include: [:ingredients, :equipment, :notes, :instructions]), status: :created
        else
          render json: @recipe.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /recipes/1
      def update
        if @recipe.update(recipe_params)
          render json: @recipe
        else
          render json: @recipe.errors, status: :unprocessable_entity
        end
      end
    
      # DELETE /recipes/1
      def destroy
        @recipe.destroy
      end
    
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_recipe
          @recipe = current_user.recipes.find(params[:id])
        end
    
        # Only allow a trusted parameter "white list" through.
        def recipe_params
          params.require(:recipe).permit(:title, :source_url)
        end
    end    
  end
end
