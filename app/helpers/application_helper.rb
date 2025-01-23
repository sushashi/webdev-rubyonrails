module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return if current_user.nil?

    content_tag(:div, class: "d-flex gap-2") do
      concat link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
      if current_user.admin?
        concat button_to('Destroy', item, method: :delete,
                                          form: { data: { turbo_confirm: "Are you sure ?" } },
                                          class: "btn btn-danger")
      end
      # raw("#{edit} #{del}")
    end
  end
end
