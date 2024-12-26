require 'rails_helper'

RSpec.describe "admin/addresses/index", type: :view do
  before(:each) do
    assign(:admin_addresses, [
      Admin::Address.create!(
        first_name: "First Name",
        last_name: "Last Name",
        user: nil,
        building: "Building",
        street: "Street",
        city: nil,
        phone: 2
      ),
      Admin::Address.create!(
        first_name: "First Name",
        last_name: "Last Name",
        user: nil,
        building: "Building",
        street: "Street",
        city: nil,
        phone: 2
      )
    ])
  end

  it "renders a list of admin/addresses" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("First Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Last Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Building".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Street".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
