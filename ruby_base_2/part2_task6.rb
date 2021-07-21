cart = {}

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
cart.each do |item, params| 
  sum += params[:price] * params[:amount]
  puts "Item: #{item}, price: #{params[:price]}, amount: #{params[:amount]}. Cost - #{params[:price] * params[:amount]}"
end

puts "Total cost: #{sum}"
