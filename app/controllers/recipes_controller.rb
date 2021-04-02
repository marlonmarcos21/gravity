class RecipesController < ApplicationController
  authorize_resource

  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def edit
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      redirect_to @recipe, notice: 'Recipe was successfully created!'
    else
      render :new
    end
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: 'Recipe was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @blog.destroy
    respond_to do |format|
      flash[:notice] = 'Blog successfully deleted!'
      format.html { redirect_to blogs_url }
      format.json { render json: { message: 'Blog deleted!' } }
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:ingredients, :instructions)
  end
end
