class Admin::LayersController < Admin::AdminController

  def index
    @layers = Layer.all
  end

  def new
    @layer = Layer.new
  end

  def create
    @layer = Layer.new(params[:layer])
    @layer.date = Date.today
    # @layer.status = true;
    if @layer.save
      flash[:notice] = 'Layer created successfully.'
      redirect_to edit_admin_layer_path(@layer), :flash => {:success => 'Layer has been created successfully'}
    else
      render :action => 'new'
    end
  end

  def edit
    @layer = Layer.find(params[:id])
  end

  def update
    @layer = Layer.find(params[:id])
    @layer.attributes = params[:layer]

    if @layer.save
      flash[:notice] = 'Layer updated successfully.'

      redirect_to edit_admin_layer_path(@layer), :flash => {:success => 'Organization has been updated successfully'}
    else
      flash.now[:error] = @layer.errors.full_messages
      render :action => 'edit'
    end
  end

  def destroy
    @layer = Layer.find(params[:id])
    sl = SiteLayer.where(:layer_id => @layer.id)
    sql = """ DELETE FROM site_layers WHERE layer_id = #{@layer.id} """
    ActiveRecord::Base.connection.execute(sql)
    @layer.destroy
    redirect_to admin_layers_path, :flash => {:success => 'Layer has been deleted successfully'}
  end
end
