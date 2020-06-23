module Api
  class PolygonsController < ApiController
    def index
      @polygons = Polygon.all.order(created_at: :desc)

      render_success_response(@polygons)
    end

    def create
      params[:data].each do |polygon|
        Polygon.create(value: polygon[:geometry][:coordinates])
      end

      render_success_response
    end

    def destroy
      polygon = Polygon.find(params[:id])
      polygon.destroy ? render_success_response : :render_error_response
    end
  end
end
