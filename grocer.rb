def consolidate_cart(cart)
  output = {}

  cart.each do |item|
    if !output.keys.include?(item.keys[0])
      output[item.keys[0]] = item.values[0]
      output[item.keys[0]][:count] = 1
    else
      output[item.keys[0]][:count] += 1
    end
  end

  output
end


def apply_coupons(cart, coupons)
  for coupon in coupons
    if cart.keys.include?(coupon[:item]) && !cart["#{coupon[:item]} W/COUPON"]
      cart["#{coupon[:item]} W/COUPON"] = {}
      cart["#{coupon[:item]} W/COUPON"][:price] = coupon[:cost]
      cart["#{coupon[:item]} W/COUPON"][:clearance] = cart[coupon[:item]][:clearance]
      cart["#{coupon[:item]} W/COUPON"][:count] = 0
    end

    if cart["#{coupon[:item]} W/COUPON"]
      cart[coupon[:item]][:count] -= coupon[:num]
      cart["#{coupon[:item]} W/COUPON"][:count] += 1
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |item, data|
    if data[:clearance] == true
      data[:price] = (data[:price] * 0.80).round(2)
    end
  end

  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  
  cart = apply_coupons(cart, coupons)
  
  cart = apply_clearance(cart)
  
  cart.sum do |item, data|
    data[:price]
  end
end