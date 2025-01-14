require 'rails_helper'

RSpec.describe "admin/coupons/index", type: :view do
  before(:each) do
    assign(:admin_coupons, [
      Admin::Coupon.create!(
        code: "Code",
        discount: "9.99",
        description: "MyText",
        max_usage: 2,
        status: false
      ),
      Admin::Coupon.create!(
        code: "Code",
        discount: "9.99",
        description: "MyText",
        max_usage: 2,
        status: false
      )
    ])
  end

  it "renders a list of admin/coupons" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
