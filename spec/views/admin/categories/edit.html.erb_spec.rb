require 'rails_helper'

RSpec.describe "admin/categories/edit", type: :view do
  let(:admin_category) {
    Admin::Category.create!(
      name: "MyString",
      description: "MyText"
    )
  }

  before(:each) do
    assign(:admin_category, admin_category)
  end

  it "renders the edit admin_category form" do
    render

    assert_select "form[action=?][method=?]", admin_category_path(admin_category), "post" do

      assert_select "input[name=?]", "admin_category[name]"

      assert_select "textarea[name=?]", "admin_category[description]"
    end
  end
end
