module Admin
  class CategoriesController < ApplicationController
    before_action :set_category, only: %i[edit update destroy]

    def index
      @categories = Category.includes(:parent).order(:name)
    end

    def new
      @category = Category.new
      load_parents
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "Category created."
      else
        load_parents
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      load_parents
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Category updated."
      else
        load_parents
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: "Category deleted."
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def load_parents
      @parents = Category.where.not(id: @category&.id).order(:name)
    end

    def category_params
      params.require(:category).permit(:name, :slug, :description, :parent_id, :enabled)
    end
  end
end
