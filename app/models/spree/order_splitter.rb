module Spree
  class OrderSplitter
    attr_accessor :order

    def initialize(order)
      @order = order
    end

    def split!
      order.variants.group_by(&:vendor_id).each do |vendor_id, variants|
        next if vendor_id.nil?
        vendor_order = order.clone
        vendor_order.update(vendor_id: vendor_id, parent_order_id: order.id)
        create_line_items(vendor_order, variants.map(&:id))
        vendor_order.create_proposed_shipments
        vendor_order.update_with_updater!
        vendor_order.shipment_total=0
        vendor_order.updater.update_order_total
        vendor_order.updater.persist_totals
      end
    end

    private

    def create_line_items(vendor_order, variant_ids)
      order.line_items.where(variant_id: variant_ids).each do |line_item|
        line_item.update(order_id: vendor_order.id)
      end
    end
  end
end
