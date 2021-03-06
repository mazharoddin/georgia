module Georgia
  module FormsHelper

    def sortable(column, title=nil)
      title ||= column.humanize
      direction = (column.to_s == params[:o] && params[:dir] == "asc" ? "desc" : "asc")
      icon = direction == "asc" ? icon_tag('caret-up') : icon_tag('caret-down')
      "#{title}&nbsp;#{link_to(icon, params.merge({o: column, dir: direction}))}".html_safe
    end

    def render_template template
      begin
        render "georgia/pages/templates/#{template}", template: template
      rescue
        render "georgia/pages/templates/custom", template: template
      end
    end

    def button_to_save text=nil
      text ||= "#{icon_tag 'check'} Save".html_safe
      content_tag :button, text, type: "submit", class: "btn btn-save"
    end

    def choose_image_tag imageable, args={}
      Georgia::MediaLibraryPresenter.new(self, imageable, args).to_s
    end

    def widget_portlet_tag ui_association, args={}
      Georgia::WidgetPortlet.new(self, ui_association, args)
    end

    def slide_portlet_tag slide, args={}
      Georgia::SlidePortlet.new(self, slide, args)
    end

    def link_portlet_tag link, args={}
      Georgia::LinkPortlet.new(self, link, args)
    end

    def subpage_portlet_tag subpage, args={}
      Georgia::SubpagePortlet.new(self, subpage, args)
    end

    def parent_page_collection
      @parent_page_collection ||= Georgia::Page.not_self(@page).joins(current_revision: :contents).uniq.sort_by(&:title).map{|p| [p.title, p.id]}
    end

    def widgets_collection
      @widgets_collection ||= options_from_collection_for_select(Georgia::Widget.all, :id, :title)
    end

    def extra_fields?
      lookup_context.exists?('extra_fields', ["#{klass_folder}/fields"], true)
    end

    def extra_fields_path
      "#{klass_folder}/fields/extra_fields"
    end

    private

    def klass_folder
      klass = @page.try(:decorated?) ? @page.model.class : @page.class
      @klass_folder ||= klass.to_s.underscore.pluralize
    end

  end
end
