module Spree
  class ShippingMethodsController < Spree::StoreController

    layout nil

    ssl_allowed :index

    respond_to :json

    def index
      if params['state'].present? and params['country_id'].present?
        if current_order.ship_address.nil?
          current_order.ship_address = Address.create
        else
          current_order.ship_address.state_id = nil
          current_order.ship_address.state_name = nil
        end
        current_order.ship_address.country_id = params['country_id']
        Float(params['state']) != nil rescue false ? current_order.ship_address.state_id = params['state'] : current_order.ship_address.state_name = params['state']
        current_order.save(:validate => false)

        render :json => current_order.create_proposed_shipments
      else
        render :json => nil
      end
    end

  end
end