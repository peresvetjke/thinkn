cart = Hash.new

loop do
  print "Product name: "
  item = gets.chomp
  break if item == "stop"
  print "Price: "
  price = gets.chomp.to_f
  print "Amount: "
  amount = gets.chomp.to_f

  cart[item.to_sym] = {price: price, amount: amount}

end

puts "cart = #{cart}"

sum = 0
cart.each do |x, y| 
  sum += y[:price] * y[:amount]
  puts "Item: #{x}, price: #{y[:price]}, amount: #{y[:amount]}. Cost - #{y[:price] * y[:amount]}"
end

puts "Total cost: #{sum}"
