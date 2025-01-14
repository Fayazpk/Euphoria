require 'rails_helper'

RSpec.describe "admin/coupons/edit", type: :view do
  let(:admin_coupon) {
    Admin::Coupon.create!(
      code: "MyString",
      discount: "9.99",
      description: "MyText",
      max_usage: 1,
      status: false
    )
  }

  before(:each) do
    assign(:admin_coupon, admin_coupon)
  end

  it "renders the edit admin_coupon form" do
    render

    assert_select "form[action=?][method=?]", admin_coupon_path(admin_coupon), "post" do

      assert_select "input[name=?]", "admin_coupon[code]"

      assert_select "input[name=?]", "admin_coupon[discount]"

      assert_select "textarea[name=?]", "admin_coupon[description]"

      assert_select "input[name=?]", "admin_coupon[max_usage]"

      assert_select "input[name=?]", "admin_coupon[status]"
    end
  end
end
