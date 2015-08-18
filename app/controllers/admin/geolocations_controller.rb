class Admin::GeolocationsController < Admin::AdminController
  respond_to :json
  def index
    level = params[:level] if params[:level].present?
    geolocation = params[:geolocation]
    @geolocations = Geolocation.fetch_all(level, geolocation)
    render :json => @geolocations.to_json
  end
end
