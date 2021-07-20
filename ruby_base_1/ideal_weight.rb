print "Please enter your name: "
name = gets.chomp

print "Enter your height: "
height = gets.chomp.to_f

ideal_weight = (height - 110) * 1.15

if ideal_weight < 0
  puts "#{name}, your weight is already optimal!" 
else
  puts "#{name}, your ideal weight would be #{ideal_weight}."
end