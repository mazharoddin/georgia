module Georgia
  module PagesHelper

    def page_actions_tag page, revision=nil, options={}
      revision ||= page.current_revision
      Georgia::PageActionsPresenter.new(self, page, revision, options)
    end

    def button_to_settings
      link_to icon_tag('cogs'), [:settings, @page], class: 'btn btn-default'
    end

  end
end
