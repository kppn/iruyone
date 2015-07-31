json.array!(@orders) do |order|
  json.extract! order, :client, :status, :order_message, :payment, :num_comment, :num_view, :num_pop, :order_date, :close_date, :list_image_name
  json.url order_url(order, format: :json)
end