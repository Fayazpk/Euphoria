require 'rails_helper'

RSpec.describe "admin/users/index", type: :view do
  before(:each) do
    assign(:admin_users, [
      Admin::User.create!(
        email: "Email",
        password_digest: "Password Digest",
        is_blocked: false
      ),
      Admin::User.create!(
        email: "Email",
        password_digest: "Password Digest",
        is_blocked: false
      )
    ])
  end

  it "renders a list of admin/users" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Password Digest".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
