module Api
  module V1
    class RecipesController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_recipe, only: [:show, :update, :destroy]
    
      # GET /recipes
      def index
        @recipes = current_user.recipes.all.order(created_at: :desc)
        render json: @recipes.to_json(include: [:ingredients, :equipment, :notes, :instructions]), status: :ok
      end
    
      # GET /recipes/1
      def show
        render json: @recipe.to_json(include: [:ingredients, :equipment, :notes, :instructions]), status: :ok
      end
    
      # POST /recipes
      def create
        source_url = recipe_params[:source_url]
        recipe = { title: recipe_params[:title], scale_factor: 1 }
        # TODO: move elsewhere
        base_endpoint = 'https://api.spoonacular.com/recipes'
        api_key = '61da5a0bce374243a421ab56e2b092bc'

        url = base_endpoint + '/extract?apiKey=' + api_key + '&url=' + source_url

        status = 404
        if source_url.present?
          response = HTTParty.get(url)
          status = response.code
        end

        if status == 200
          recipe[:source_url] = source_url
          title, ready_in_minutes, analyzed_instructions, ext_ingredients = response.parsed_response.values_at('title', 'readyInMinutes', 'analyzedInstructions', 'extendedIngredients')
          recipe[:title] = title
          recipe[:ready_in_minutes] = ready_in_minutes
        end

        @recipe = current_user.recipes.build(recipe)

        if status == 200
          instr_index = 0
          analyzed_instructions.each { |instr|
            instr['steps'].each { |step|
              @recipe.instructions.build({
                index: instr_index,
                text: step['step']
              })

              step['equipment'].each { |equipment|
                @recipe.equipment.build({
                  name: equipment['name'],
                  in_shopping_list: false
                })
              }

              instr_index += 1
            }
          }

          ext_ingredients.each { |ingr|
            @recipe.ingredients.build({
              name: ingr['originalName'],
              in_shopping_list: false,
              amount: ingr['amount'],
              unit: ingr['unit']
            })
          }
        end

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
