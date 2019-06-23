require_relative 'grocer'
require 'pry'
def items
	[
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
		{"ALMONDS" => {:price => 9.00, :clearance => false}},
		{"TEMPEH" => {:price => 3.00, :clearance => true}},
		{"CHEESE" => {:price => 6.50, :clearance => false}},
		{"BEER" => {:price => 13.00, :clearance => false}},
		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
		{"BEETS" => {:price => 2.50, :clearance => false}}
	]
end

def coupons
	[
		{:item => "AVOCADO", :num => 2, :cost => 5.00},
		{:item => "BEER", :num => 2, :cost => 20.00},
		{:item => "CHEESE", :num => 3, :cost => 15.00}
	]
end

def generate_cart
	[].tap do |cart|
		rand(20).times do
			cart.push(items.sample)
		end
	end
end

def generate_coupons
	[].tap do |c|
		rand(2).times do
			c.push(coupons.sample)
		end
	end
end

def consolidate_cart(cart)
	binding.pry
	cons_cart = {}
	binding.pry
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

#[{:item=>"AVOCADO", :num=>2, :cost=>5.0}]
def apply_coupons(cart,coupons)
	coupons.each do |coup_hash|
		item_name = coup_hash[:item]
		new_name = "#{item_name} W/COUPON"
		coupon_count = coup_hash[:num]
		price_per_item = coup_hash[:cost]/coupon_count
		if cart[item_name] != nil
			cart[item_name][:count] -= coupon_count
			cart[new_name] = {
				:price => price_per_item,
				:clearance => cart[item_name][:clearance],
				:count => coupon_count
			}
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
	total_cost.round(2)
end
 
cart = generate_cart
# puts "----------------------"
# puts cart
# puts "----------------------"
coupons = generate_coupons

new_cart = consolidate_cart(cart)


puts new_cart

puts "Items in cart"
cart.each do |item|
	puts "Item: #{item.keys.first}"
	puts "Price: #{item[item.keys.first][:price]}"
	puts "Clearance: #{item[item.keys.first][:clearance]}"
	puts "=" * 10
end


puts "Coupons on hand"
coupons.each do |coupon|
	puts "Get #{coupon[:item].capitalize} for #{coupon[:cost]} when you by #{coupon[:num]}"
end

puts "Your total is #{checkout(cart, coupons)}"

