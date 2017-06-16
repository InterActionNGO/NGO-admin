class Admin::TagsController < ApplicationController

  before_filter :login_required
  before_filter :redirect_unauthorized
  
  def index
    
    tags = Tag.scoped
    @conditions = {}
    
    if params[:q]
       unless params[:q].blank?
            q = "%#{params[:q].sanitize_sql!}%"
            tags = Tag.where(["name ilike ? OR description ilike ?", q, q])
            @conditions['text contains'] = q[1..-2]
       end
    end
    @tags = tags.order('count desc, name asc').paginate :per_page => 50, :page => params[:page]
    
  end
  
  def new
      @tag = Tag.new
  end
  
  def create
      @tag = Tag.new(tag_params)
      if @tag.save
      flash[:notice] = 'Tag created successfully.'
      redirect_to edit_admin_tag_path(@tag)
    else
      render :action => 'new'
    end
  end
  
  def edit
      @tag = Tag.find(params[:id])
  end
  
  def update
    @tag = Tag.find(params[:id])
    @tag.attributes = tag_params

    if @tag.save
      flash[:notice] = 'Tag updated successfully.'

      redirect_to edit_admin_tag_path(@tag)
    else
      flash.now[:error] = @tag.errors.full_messages
      render :action => 'edit'
    end
  end
  
  def destroy
    @tag = Tag.find(params[:id])
    if @tag.destroy
        flash[:notice] = 'Tag deleted successfully'
        redirect_to admin_tags_path
    else
      flash.now[:error] = @tag.errors.full_messages
      render :action => 'edit'
    end
  end
  
  private
  def tag_params
     params.require(:tag).permit(:name, :description) 
  end

end
