module Admin::OrdersHelper
  def status_class(status)
    {
      "pending" => "bg-warning text-dark",
      "processing" => "bg-primary",
      "shipped" => "bg-info",
      "delivered" => "bg-success",
      "cancelled" => "bg-danger"
    }[status] || "bg-secondary"
  end

  def payment_status_class(status)
    {
      "pending" => "bg-warning text-dark",
      "completed" => "bg-success",
      "cancelled" => "bg-danger",
      "failed" => "bg-danger"
    }[status] || "bg-secondary"
  end
end
