require 'rails_helper'

RSpec.describe "admin/coupons/show", type: :view do
  before(:each) do
    assign(:admin_coupon, Admin::Coupon.create!(
      code: "Code",
      discount: "9.99",
      description: "MyText",
      max_usage: 2,
      status: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
  end
end
