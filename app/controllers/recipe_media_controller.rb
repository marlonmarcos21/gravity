class RecipeMediaController < ApplicationController
  load_and_authorize_resource

  def show; end

  def new
    @recipe_medium = RecipeMedium.new
  end

  def edit; end

  def create
    @recipe_medium = RecipeMedium.new(recipe_medium_params)

    respond_to do |format|
      if @recipe_medium.save
        format.html { redirect_to @recipe_medium, notice: 'File was successfully created.' }
        format.json do
          render json: {
            id: @recipe_medium.id,
            file_data: @recipe_medium.file_data,
            url: @recipe_medium.file_url
          }, status: :created
        end
      else
        format.html { render :new }
        format.json { render json: @recipe_medium.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @recipe_medium.update(recipe_medium_params)
      redirect_to @recipe_medium, notice: 'File was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @recipe_media.destroy
    redirect_to :root, notice: 'File was successfully destroyed.'
  end

  private

  def set_recipe_medium
    @recipe_medium = RecipeMedium.find(params[:id])
  end

  def recipe_medium_params
    params.require(:recipe_medium).permit(:file)
  end
end
