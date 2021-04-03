class RecipesController < ApplicationController
  load_and_authorize_resource

  def index
    recipe_scope = Recipe.includes(:user).published.descending
    @recipes     = recipe_scope.page(1)
    @has_more_results = recipe_scope.page(2).exists?
  end

  def more_published_recipes
    recipe_scope = Recipe.includes(:user).published.descending
    page = params[:page].blank? ? 2 : params[:page].to_i
    @next_page = page + 1
    @recipes = recipe_scope.page(page)
    @has_more_results = recipe_scope.page(@next_page).exists?

    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end

  def show
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
    @recipe.destroy
    respond_to do |format|
      flash[:notice] = 'Recipe successfully deleted!'
      format.html { redirect_to recipes_url }
      format.json { render json: { message: 'Blog deleted!' } }
    end
  end

  def publish
    if @recipe.publish!
      redirect_to @recipe, notice: 'Recipe published!'
    else
      render :edit, alert: 'Error publishing recipe!'
    end
  end

  def unpublish
    @recipe.unpublish!
    redirect_to @recipe, alert: 'Recipe unpublished!'
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :ingredients, :instructions)
  end
end
