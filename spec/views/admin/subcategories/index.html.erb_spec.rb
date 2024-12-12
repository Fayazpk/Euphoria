require 'rails_helper'

RSpec.describe "admin/subcategories/index", type: :view do
  before(:each) do
    assign(:admin_subcategories, [
      Admin::Subcategory.create!(
        name: "Name",
        description: "MyText",
        category: nil
      ),
      Admin::Subcategory.create!(
        name: "Name",
        description: "MyText",
        category: nil
      )
    ])
  end

  it "renders a list of admin/subcategories" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
