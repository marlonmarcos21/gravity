class RecipeCategoriesController < ApplicationController
  load_resource class: Category

  def recipes
    recipe_scope      = @recipe_category.recipes.includes(:user).published.descending
    @recipes          = recipe_scope.page(1)
    @has_more_results = recipe_scope.page(2).exists?
    @through_category = true

    render 'recipes/index'
  end

  def more_published_recipes
    recipe_scope      = @recipe_category.recipes.includes(:user).published.descending
    page              = params[:page].blank? ? 2 : params[:page].to_i
    @next_page        = page + 1
    @recipes          = recipe_scope.page(page)
    @has_more_results = recipe_scope.page(@next_page).exists?
    @through_category = true

    respond_to do |format|
      format.html { render 'recipes/index' }
      format.js   { render 'recipes/more_published_recipes' }
    end
  end
end
