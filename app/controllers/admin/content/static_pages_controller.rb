module Admin
  module Content
    class StaticPagesController < Admin::BaseController
      def index
        @pages = ::StaticPage.all
      end

      def edit
        @page = ::StaticPage.find(params[:id])
      end

      def update
        @page = ::StaticPage.find(params[:id])
        if @page.update(page_params)
          audit_log!(action: "updated_page", target: @page)
          redirect_to admin_content_static_pages_path, notice: "Page mise à jour."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def page_params
        params.require(:static_page).permit(:title, :body_html)
      end
    end
  end
end
