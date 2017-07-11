class Admin::StoriesController < Admin::AdminController

  def index
    
    stories = Story.scoped
    @conditions = {}
    
    if params[:q]
       unless params[:q].blank?
            q = "%#{params[:q].sanitize_sql!}%"
            stories = Story.where(["name ilike ? OR story ilike ?", q, q])
            @conditions['text contains'] = q[1..-2]
       end
       unless params[:name].blank?
           stories = stories.where(:name => params[:name])
           @conditions['Name'] = params[:name]
       end
       unless params[:organization].blank?
           stories = stories.where(:organization => params[:organization])
           @conditions['Organization'] = params[:organization]
       end
       unless params[:reviewed].blank?
           stories = stories.where(:reviewed => params[:reviewed])
           @conditions['Reviewed'] = params[:reviewed]
       end
       unless params[:published].blank?
           stories = stories.where(:published => params[:published])
           @conditions['Published'] = params[:published]
       end
    end
    @stories_query_total = stories.count
    @stories = stories.order('created_at desc').paginate :per_page => 25, :page => params[:page]
    
  end
  
  def new
      @story = Story.new
  end
  
    def create
        @story = Story.new(story_params)
        if @story.save
            flash[:notice] = 'Story created successfully.'
            redirect_to edit_admin_story_path(@story)
            AlertsMailer.new_story_notice(@story).deliver
        else
            flash[:error] = @story.errors.full_messages
            render :action => 'new'
        end
    end
  
  def edit
      @story = Story.find(params[:id])
      @current_user = current_user
  end
  
  def update
    @story = Story.find(params[:id])
    @story.attributes = story_params
    @story.last_reviewed_by_id = current_user.id if @story.published_changed? && !@story.published.nil?

    if @story.save
      flash[:notice] = 'Story updated successfully.'

      redirect_to edit_admin_story_path(@story)
    else
      flash.now[:error] = @story.errors.full_messages
      render :action => 'edit'
    end
  end
  
  def destroy
    @story = Story.find(params[:id])
    if @story.destroy
        flash[:notice] = 'Story deleted successfully'
        redirect_to admin_stories_path
    else
      flash.now[:error] = @story.errors.full_messages
      render :action => 'edit'
    end
  end

  private
  def story_params
     params.require(:story).permit(:name, :story, :email, :organization, :image, :published, :user_profession, :reviewed)
  end

end
