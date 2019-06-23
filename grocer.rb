def consolidate_cart(cart)

	cons_cart = {}

	cart.each do |item_hash|
		item_name = item_hash.keys[0]
		if cons_cart[item_name] == nil
			cons_cart[item_name] = item_hash[item_name]
			cons_cart[item_name][:count] = 1
		else
			current_count = cons_cart[item_name][:count]
			cons_cart[item_name][:count] = current_count + 1
		end
	end
	cons_cart
end

def apply_coupons(cart,coupons)
	coupons.each do |coup_hash|
		item_name = coup_hash[:item]
		new_name = "#{item_name} W/COUPON"
		coupon_count = coup_hash[:num]
		price_per_item = coup_hash[:cost]/coupon_count
    if cart[item_name] != nil
      if cart[item_name][:count] >= coupon_count
        cart[item_name][:count] -= coupon_count
        if cart[new_name] == nil
          cart[new_name] = {
            :price => price_per_item,
            :clearance => cart[item_name][:clearance],
            :count => coupon_count
          }
        else
          cart[new_name][:count] += coupon_count
        end
      end
		end

	end
	cart
end

def apply_clearance(cart)
	cart.each do |item, item_hash|
		if item_hash[:clearance] == true
			old_price = item_hash[:price]

			new_price = (old_price * 0.80).round(2)
			item_hash[:price] = new_price
		end
	end

	cart
end

def checkout(cart,coupons)
	cons_cart = consolidate_cart(cart)
	coup_cart = apply_coupons(cons_cart,coupons)
	clear_cart = apply_clearance(coup_cart)
	total_cost = 0
	clear_cart.each do |item, item_hash|
		total_cost += item_hash[:count] * item_hash[:price]
  end
  if total_cost > 100
    total_cost *= 0.9
  end
	total_cost.round(2)
end
