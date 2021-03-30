module ApplicationHelper
    include Pagy::Frontend

    def crud_label(key)
        case key
            when 'create'
                tag.i class: ' fa fa-plus text-success'
            when 'update'
                tag.i class: ' fa fa-pen '
            when 'destroy'
            tag.i class: ' fa fa-trash text-danger'
        end
    end
    
end
