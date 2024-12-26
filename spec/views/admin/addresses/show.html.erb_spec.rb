require 'rails_helper'

RSpec.describe "admin/addresses/show", type: :view do
  before(:each) do
    assign(:admin_address, Admin::Address.create!(
      first_name: "First Name",
      last_name: "Last Name",
      user: nil,
      building: "Building",
      street: "Street",
      city: nil,
      phone: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Building/)
    expect(rendered).to match(/Street/)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
  end
end
