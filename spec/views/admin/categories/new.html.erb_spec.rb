require 'rails_helper'

RSpec.describe "admin/categories/new", type: :view do
  before(:each) do
    assign(:admin_category, Admin::Category.new(
      name: "MyString",
      description: "MyText"
    ))
  end

  it "renders new admin_category form" do
    render

    assert_select "form[action=?][method=?]", admin_categories_path, "post" do

      assert_select "input[name=?]", "admin_category[name]"

      assert_select "textarea[name=?]", "admin_category[description]"
    end
  end
end
