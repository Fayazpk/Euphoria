require 'rails_helper'

RSpec.describe "admin/products/show", type: :view do
  before(:each) do
    assign(:admin_product, Admin::Product.create!(
      name: "Name",
      description: "Description",
      category: nil,
      subcategory: nil,
      size: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
