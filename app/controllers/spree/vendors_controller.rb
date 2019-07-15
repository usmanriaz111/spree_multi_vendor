module Spree
  class VendorsController < Spree::StoreController
    before_action :set_spree_vendor, only: [:show]

    def index
      if params[:keywords].present?
        params[:q] = {name_cont: params[:keywords]}
        @q = Spree::Vendor.ransack(params[:q])
        @stores = @q.result(distinct: true).approved
        @keywords = params[:keywords]
        @available_products = params[:available_products].present? ? params[:available_products] : false
        @available_stores = true
        @available_categories = params[:available_categories].present? ? params[:available_categories] : false

      else
        @stores = Spree::Vendor.approved
      end
    end

    def show
      @store_products = @store.products.in_stock.approved
    end
    def get_store_products
      store = Spree::Vendor.friendly.find(params[:id])
      @products = store.products.approved.in_stock.distinct
      @p_count = @products.count
      @title = store.name
      if params[:store_slug].present?
        @store_slug = params[:store_slug]
      end
    end

    private
      def set_spree_vendor
        @store = Spree::Vendor.friendly.find(params[:id])
      end
  end
end