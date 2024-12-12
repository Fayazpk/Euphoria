require "rails_helper"

RSpec.describe Admin::SubcategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/subcategories").to route_to("admin/subcategories#index")
    end

    it "routes to #new" do
      expect(get: "/admin/subcategories/new").to route_to("admin/subcategories#new")
    end

    it "routes to #show" do
      expect(get: "/admin/subcategories/1").to route_to("admin/subcategories#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/subcategories/1/edit").to route_to("admin/subcategories#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/admin/subcategories").to route_to("admin/subcategories#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/subcategories/1").to route_to("admin/subcategories#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/subcategories/1").to route_to("admin/subcategories#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/subcategories/1").to route_to("admin/subcategories#destroy", id: "1")
    end
  end
end
