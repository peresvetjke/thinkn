require 'set'

puts "Please enter values of triangles's sides:"
print "a = "
a = gets.chomp.to_f
print "b = "
b = gets.chomp.to_f
print "c = "
c = gets.chomp.to_f

unless (a + b > c) && (b + c > a) && (a + c > b)
  puts "Triangle doesn't exit"
  exit
end

arr = [a,b,c].sort!
s = arr.to_set

puts "Triangle is right." if arr[2]**2 == arr[0]**2 + arr[1]**2
if s.size == 1
  puts "Triangle is equilateral (3 sides have the same length)."
elsif s.size == 2
  puts "Triangle is isosceles (2 sides have the same length). "
end



