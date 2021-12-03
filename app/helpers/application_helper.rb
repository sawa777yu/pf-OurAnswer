module ApplicationHelper

  def sort_order(column)
    direction = (column == sort_column && sort_direction == "desc") ? "asc" : "desc"
    link_to content_tag(:i,"",class: "fas fa-sort"), { column: column, direction: direction }
  end

end
