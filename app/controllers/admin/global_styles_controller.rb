module Admin
  class GlobalStylesController < ApplicationController
    before_action :set_global_style

    def edit; end

    def update
      if @global_style.update(tokens: global_style_params.fetch(:tokens, {}).to_h)
        redirect_to edit_admin_global_style_path, notice: "Global styles updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_global_style
      @global_style = GlobalStyle.active.first || GlobalStyle.find_or_create_by!(name: "Default") do |style|
        style.active = true
        style.tokens = {}
      end
    end

    def global_style_params
      params.require(:global_style).permit(
        tokens: {
          colors: %i[primary secondary text background],
          typography: {
            heading: %i[font_family font_weight],
            body: %i[font_family font_weight]
          },
          layout: %i[container_width gutter section_spacing]
        }
      )
    end
  end
end
