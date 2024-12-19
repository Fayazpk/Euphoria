require 'rails_helper'

RSpec.describe "admin/users/edit", type: :view do
  let(:admin_user) {
    Admin::User.create!(
      email: "MyString",
      password_digest: "MyString",
      is_blocked: false
    )
  }

  before(:each) do
    assign(:admin_user, admin_user)
  end

  it "renders the edit admin_user form" do
    render

    assert_select "form[action=?][method=?]", admin_user_path(admin_user), "post" do

      assert_select "input[name=?]", "admin_user[email]"

      assert_select "input[name=?]", "admin_user[password_digest]"

      assert_select "input[name=?]", "admin_user[is_blocked]"
    end
  end
end
