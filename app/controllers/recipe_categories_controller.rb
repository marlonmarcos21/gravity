class RecipeCategoriesController < ApplicationController
  load_resource

  def recipes
    recipe_scope = @recipe_category.recipes.includes(:user).published.descending
    @recipes     = recipe_scope.page(1)
    @has_more_results = recipe_scope.page(2).exists?

    render 'recipes/index'
  end
end
