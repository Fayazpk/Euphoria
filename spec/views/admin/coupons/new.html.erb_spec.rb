require 'rails_helper'

RSpec.describe "admin/coupons/new", type: :view do
  before(:each) do
    assign(:admin_coupon, Admin::Coupon.new(
      code: "MyString",
      discount: "9.99",
      description: "MyText",
      max_usage: 1,
      status: false
    ))
  end

  it "renders new admin_coupon form" do
    render

    assert_select "form[action=?][method=?]", admin_coupons_path, "post" do

      assert_select "input[name=?]", "admin_coupon[code]"

      assert_select "input[name=?]", "admin_coupon[discount]"

      assert_select "textarea[name=?]", "admin_coupon[description]"

      assert_select "input[name=?]", "admin_coupon[max_usage]"

      assert_select "input[name=?]", "admin_coupon[status]"
    end
  end
end
