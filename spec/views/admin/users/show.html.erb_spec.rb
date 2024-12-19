require 'rails_helper'

RSpec.describe "admin/users/show", type: :view do
  before(:each) do
    assign(:admin_user, Admin::User.create!(
      email: "Email",
      password_digest: "Password Digest",
      is_blocked: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Password Digest/)
    expect(rendered).to match(/false/)
  end
end
