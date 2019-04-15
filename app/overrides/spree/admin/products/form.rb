Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'Enable vendors to manage product master price',
  replace: 'div[data-hook="admin_product_form_price"]',
  text: <<-HTML
         <div data-hook="admin_product_form_price">
          <%= f.field_container :price, class: ['form-group'] do %>
            <%= f.label :price, raw(Spree.t(:master_price) + content_tag(:span, ' *', class: "required")) %>
            <%= f.text_field :price, value: number_to_currency(@product.price, unit: ''), class: 'form-control', disabled: (cannot? :update, Spree::Price) %>
            <%= f.error_message_on :price %>
          <% end %>
         </div>
        HTML
)

Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'product status dropdown',
  insert_before: 'div[data-hook="admin_product_form_price"]',
  text: <<-HTML
          <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
            <div data-hook="admin_product_form_status">
              <%= f.field_container :status, class: ['form-group'] do %>
                <%= f.label :status, Spree.t(:status) %>
                <%= select_tag "product[status]", options_for_select(::Spree::Product.statuses.map{|k,v| [k.humanize,k] },f.object.status), class: 'select2' %>
                <%= f.error_message_on :status %>
              <% end %>
            </div>
          <% else %>
            <div data-hook="admin_product_form_status">
              <p><strong>Status:</strong></p> <%= f.object.status.present? ? f.object.status : "" %> %>
            </div>
          <% end %>
        HTML
)



Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'Add vendor select in product form',
  insert_before: 'div[data-hook="admin_product_form_price"]',
  text: <<-HTML
          <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
            <%= f.field_container :vendor_id, class: ['form-group'] do %>
              <%= f.collection_select(:vendor_id, Spree::Vendor.all, :id, :name, {:include_blank => 'Assign Vendor'}, { class: 'select2'}) %>
            <% end %>
          <% end %>
        HTML
)
