require 'rails_helper'

RSpec.describe "admin/subcategories/new", type: :view do
  before(:each) do
    assign(:admin_subcategory, Admin::Subcategory.new(
      name: "MyString",
      description: "MyText",
      category: nil
    ))
  end

  it "renders new admin_subcategory form" do
    render

    assert_select "form[action=?][method=?]", admin_subcategories_path, "post" do

      assert_select "input[name=?]", "admin_subcategory[name]"

      assert_select "textarea[name=?]", "admin_subcategory[description]"

      assert_select "input[name=?]", "admin_subcategory[category_id]"
    end
  end
end
