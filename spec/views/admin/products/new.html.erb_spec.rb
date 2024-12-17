require 'rails_helper'

RSpec.describe "admin/products/new", type: :view do
  before(:each) do
    assign(:admin_product, Admin::Product.new(
      name: "MyString",
      description: "MyString",
      category: nil,
      subcategory: nil,
      size: nil
    ))
  end

  it "renders new admin_product form" do
    render

    assert_select "form[action=?][method=?]", admin_products_path, "post" do

      assert_select "input[name=?]", "admin_product[name]"

      assert_select "input[name=?]", "admin_product[description]"

      assert_select "input[name=?]", "admin_product[category_id]"

      assert_select "input[name=?]", "admin_product[subcategory_id]"

      assert_select "input[name=?]", "admin_product[size_id]"
    end
  end
end
