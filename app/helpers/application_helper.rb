module ApplicationHelper
	def link_to_add_fields(name, f, association)
	    new_object = f.object.send(association).klass.new
	    id = new_object.object_id
	    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      	render(association.to_s.singularize, f: builder)
    end
    	link_to(name, '#', class: "add_campaign_item btn btn-success", data: {id: id, fields: fields.gsub("\n", "")})
  	end

  def resource_name
    :client
  end

  def resource
    @resource ||= Client.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:client]
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    if column == sort_column
      if direction == "asc"
        arrow = ' <span class="entypo">&#9652;</span>'
      else
        arrow = ' <span class="entypo">&#9662;</span>'
      end
    else
      arrow = ''
    end
    link_to (title + arrow).html_safe, {:sort => column, :direction => direction}
  end

end
