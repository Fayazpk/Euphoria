require "rails_helper"

RSpec.describe Admin::AddressesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/addresses").to route_to("admin/addresses#index")
    end

    it "routes to #new" do
      expect(get: "/admin/addresses/new").to route_to("admin/addresses#new")
    end

    it "routes to #show" do
      expect(get: "/admin/addresses/1").to route_to("admin/addresses#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/addresses/1/edit").to route_to("admin/addresses#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/admin/addresses").to route_to("admin/addresses#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/addresses/1").to route_to("admin/addresses#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/addresses/1").to route_to("admin/addresses#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/addresses/1").to route_to("admin/addresses#destroy", id: "1")
    end
  end
end
