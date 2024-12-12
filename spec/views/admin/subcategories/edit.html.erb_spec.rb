require 'rails_helper'

RSpec.describe "admin/subcategories/edit", type: :view do
  let(:admin_subcategory) {
    Admin::Subcategory.create!(
      name: "MyString",
      description: "MyText",
      category: nil
    )
  }

  before(:each) do
    assign(:admin_subcategory, admin_subcategory)
  end

  it "renders the edit admin_subcategory form" do
    render

    assert_select "form[action=?][method=?]", admin_subcategory_path(admin_subcategory), "post" do

      assert_select "input[name=?]", "admin_subcategory[name]"

      assert_select "textarea[name=?]", "admin_subcategory[description]"

      assert_select "input[name=?]", "admin_subcategory[category_id]"
    end
  end
end
