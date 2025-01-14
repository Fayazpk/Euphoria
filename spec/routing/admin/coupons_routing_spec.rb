require "rails_helper"

RSpec.describe CouponsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/coupons").to route_to("admin/coupons#index")
    end

    it "routes to #new" do
      expect(get: "/admin/coupons/new").to route_to("admin/coupons#new")
    end

    it "routes to #show" do
      expect(get: "/admin/coupons/1").to route_to("admin/coupons#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/coupons/1/edit").to route_to("admin/coupons#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/admin/coupons").to route_to("admin/coupons#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/coupons/1").to route_to("admin/coupons#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/coupons/1").to route_to("admin/coupons#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/coupons/1").to route_to("admin/coupons#destroy", id: "1")
    end
  end
end
