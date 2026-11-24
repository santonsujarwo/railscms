module Admin
  class MediaAssetsController < ApplicationController
    before_action :set_media_asset, only: %i[edit update destroy]

    def index
      @media_assets = MediaAsset.includes(:uploaded_by, file_attachment: :blob).recent
    end

    def new
      @media_asset = MediaAsset.new
    end

    def create
      @media_asset = MediaAsset.new(media_asset_params.except(:file).merge(uploaded_by: current_user))
      @media_asset.file.attach(media_asset_params[:file]) if media_asset_params[:file].present?

      if @media_asset.save
        redirect_to admin_media_assets_path, notice: "Media uploaded."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @media_asset.update(media_asset_params.except(:file))
        @media_asset.file.attach(media_asset_params[:file]) if media_asset_params[:file].present?
        redirect_to admin_media_assets_path, notice: "Media details updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @media_asset.destroy
      redirect_to admin_media_assets_path, notice: "Media deleted."
    end

    private

    def set_media_asset
      @media_asset = MediaAsset.find(params[:id])
    end

    def media_asset_params
      params.require(:media_asset).permit(:alt_text, :caption, :file)
    end
  end
end
