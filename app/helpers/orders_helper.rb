module OrdersHelper
  def escape_lf_to_br(s)
    html_escape(s).gsub(/\r\n|\r|\n/, "<br>").html_safe
  end
end
