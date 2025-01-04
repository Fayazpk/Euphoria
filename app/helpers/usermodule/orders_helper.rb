module Usermodule
  module OrdersHelper
def status_class(status)
  case status
  when "pending" then "bg-warning text-dark"
  when "processing" then "bg-info text-dark"
  when "shipped" then "bg-primary"
  when "delivered" then "bg-success"
  when "cancelled" then "bg-danger"
  else "bg-secondary"
  end
end
  end
end
