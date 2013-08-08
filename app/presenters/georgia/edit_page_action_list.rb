module Georgia
  class EditPageActionList < EditRevisionActionList

    def render
      html = ""
      html << content_tag(:li, link_to_draft) if can?(:draft, instance)
      html << content_tag(:li, link_to_copy) if can?(:copy, instance)
      html << content_tag(:li, link_to_publish) if can?(:publish, instance) and !instance.published?
      html << content_tag(:li, link_to_unpublish) if can?(:unpublish, instance) and instance.published?
      html << content_tag(:li, link_to_delete) if can?(:delete, instance)
      html.html_safe
    end

    private

    def page
      @page ||= instance
    end

    def link_to_draft
      link_to "#{icon_tag('icon-paste')} Start a new Draft".html_safe, url_for_action(:draft)
    end

    def link_to_copy
      link_to "#{icon_tag('icon-copy')} Copy".html_safe, url_for_action(:copy)
    end

    def link_to_publish
      link_to "#{icon_tag('icon-thumbs-up')} Publish".html_safe, url_for_action(:publish)
    end

    def link_to_unpublish
      link_to "#{icon_tag('icon-thumbs-down')} Unpublish".html_safe, url_for_action(:unpublish), data: {confirm: 'Are you sure?'}
    end

    def link_to_delete
      options = {}
      options[:data] ||= {}
      options[:data][:confirm] = 'Are you sure?'
      options[:method] ||= :delete
      link_to "#{icon_tag('icon-trash')} Delete".html_safe, instance, options
    end

    def url_for_action action
      url_for([action, page])
    end

  end
end