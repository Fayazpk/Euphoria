require 'rails_helper'

RSpec.describe "admin/addresses/new", type: :view do
  before(:each) do
    assign(:admin_address, Admin::Address.new(
      first_name: "MyString",
      last_name: "MyString",
      user: nil,
      building: "MyString",
      street: "MyString",
      city: nil,
      phone: 1
    ))
  end

  it "renders new admin_address form" do
    render

    assert_select "form[action=?][method=?]", admin_addresses_path, "post" do

      assert_select "input[name=?]", "admin_address[first_name]"

      assert_select "input[name=?]", "admin_address[last_name]"

      assert_select "input[name=?]", "admin_address[user_id]"

      assert_select "input[name=?]", "admin_address[building]"

      assert_select "input[name=?]", "admin_address[street]"

      assert_select "input[name=?]", "admin_address[city_id]"

      assert_select "input[name=?]", "admin_address[phone]"
    end
  end
end
