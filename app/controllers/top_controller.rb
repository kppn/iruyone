class TopController < ApplicationController
  def index
    @orders = Order.all
  end
end
