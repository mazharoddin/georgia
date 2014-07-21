module Georgia
  class PagesController < ApplicationController

    include Georgia::Concerns::Helpers

    before_filter :prepare_new_page, only: [:search]
    before_filter :prepare_page, only: [:show, :edit, :settings, :update, :copy, :preview, :draft]

    def show
      authorize @page
      redirect_to [:edit, @page]
    end

    # Edit current revision
    def edit
      authorize @page
      redirect_to [:edit, @page, @page.current_revision]
    end

    # Edit current page
    def settings
      authorize @page
    end

    # Create page, load first current revision and js redirect to revisions#edit
    def create
      @page = model.new(slug: params[:title].try(:parameterize))
      authorize @page
      if @page.save
        @page.revisions.create(template: Georgia.templates.first) do |rev|
          rev.contents << Georgia::Content.new(locale: I18n.default_locale, title: params[:title])
        end
        @page.update_attribute(:current_revision, @page.revisions.first)
        CreateActivity.new(@page, :create, owner: current_user).call
        respond_to do |format|
          format.html { redirect_to edit_page_revision_path(@page, @page.current_revision), notice: "#{@page.title} was successfully created." }
          format.js { render layout: false }
        end
      else
        respond_to do |format|
          format.html { redirect_to :back, alert: "Oups. Something went wrong." }
          format.js { render layout: false }
        end
      end
    end

    # Update page settings
    def update
      authorize @page
      model.update_tree(params[:page_tree]) if params[:page_tree]
      clean_textext_tag_list_format if params[:page][:tag_list].present?
      if @page.update(page_params)
        CreateActivity.new(@page, :update, owner: current_user).call
        respond_to do |format|
          format.html { redirect_to [:settings, @page], notice: "#{@page.title} was successfully updated." }
          format.js { head :ok }
        end
      else
        respond_to do |format|
          format.html { redirect_to [:settings, @page], alert: "Oups. Something went wrong." }
          format.js { head :internal_server_error }
        end
      end
    end

    # Creates a copy of a page and redirects to its revisions#edit
    def copy
      authorize @page
      @copy = @page.copy
      CreateActivity.new(@page, :copy, owner: current_user).call
      redirect_to edit_page_revision_path(@copy, @copy.current_revision), notice: "#{instance_name.humanize} successfully copied. Do not forget to change your url"
    end

    # Destroys page and its revisions from page
    # Also used to destroy multiple pages from table checkboxes
    def destroy
      back_url = url_for(controller: controller_name, action: :search)
      @pages = model.where(id: params[:id])
      authorize @pages
      pages_count = @pages.length
      if @pages.destroy_all
        render_success("#{instance_name.humanize.pluralize(pages_count)} successfully deleted.")
      else
        render_error("Oups. Something went wrong.")
      end
    end

    # Publishes multiple pages from table checkboxes
    def publish
      set_pages
      authorize @pages

      unless @pages.map(&:publish).include?(false)
        @pages.each do |page|
          CreateActivity.new(page, :publish, owner: current_user).call
        end
        render_success("Successfully published.")
      else
        render_error("Oups. Something went wrong.")
      end
    end

    # Unpublishes multiple pages from table checkboxes
    def unpublish
      set_pages
      authorize @pages

      unless @pages.map(&:unpublish).include?(false)
        @pages.each do |page|
          CreateActivity.new(page, :unpublish, owner: current_user).call
        end
        render_success("Successfully unpublished.")
      else
        render_error("Oups. Something went wrong.")
      end
    end

    # Sorts subpages/children from pages#settings
    # FIXME: This should be taken care of in pages#update
    def sort
      if params[:page]
        params[:page].each_with_index do |id, index|
          model.update_all({position: index+1}, {id: id})
        end
      end
      render nothing: true
    end

    def index
      authorize Georgia::Page
      redirect_to [:search, model]
    end

    def search
      authorize Georgia::Page
      session[:search_params] = params
      search_conditions = model.search_conditions(params)
      @search = model.search(search_conditions).page(params[:page])
      @pages = Georgia::PageDecorator.decorate_collection(@search.records)
    end

    private

    def prepare_new_page
      @page = model.new
    end

    def prepare_page
      @page = model.find(params[:id]).decorate
    end

    def page_params
      params.require(:page).permit(permitted_page_params)
    end

    def permitted_page_params
      [:slug, :parent_id, { tag_list: [] }] + permitted_extra_params
    end

    # Override in subclass when extra fields are present
    def permitted_extra_params
      []
    end

    def clean_textext_tag_list_format
      params[:page][:tag_list] = JSON.parse(params[:page][:tag_list])
    end

    def set_pages
      @pages = model.where(id: params[:id])
    end

    def render_success success_message
      @status_message = success_message
      @status = :notice
      respond_to do |format|
        format.html { redirect_to :back, notice: @status_message }
        format.js   { render layout: false }
        format.json { render json: { ids: @pages.map(&:id), message: @status_message, status: @status } }
      end
    end

    def render_error error_message
      @status_message = error_message
      @status = :alert
      respond_to do |format|
        format.html { redirect_to :back, alert: @status_message }
        format.js   { render layout: false }
        format.json { render json: { message: @status_message, status: @status } }
      end
    end

  end
end
