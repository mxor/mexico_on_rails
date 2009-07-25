class UploadsController < ApplicationController
  before_filter :login_required

  def index
  end
  
  def create
    @upload = current_user.uploads.build(params[:upload])
    
    responds_to_parent do
      if @upload.save
        render :update do |page|
          page.insert_html :top, :uploads, :partial => @upload, :locals => {:new => true}
          page.visual_effect :appear, "asset_#{@upload.id}", :duration => 2
          page[:new_upload].reset
        end
      else
        render :update do |page|
          page.show :asset_error
          page[:new_upload].reset
        end
      end
    end
  end
end
