puts "Введите коэффициенты квадратного уравнения:"
print "a = "
a = gets.chomp.to_f
print "b = "
b = gets.chomp.to_f
print "c = "
c = gets.chomp.to_f

d = b**2 - 4*a*c

if d < 0
  puts "Ответ: корней нет."
elsif d == 0
  x1 = -b / (2*a)
  puts "Ответ: x1 = x2 = #{x1}"
elsif d > 0
  x1 = (-b + Math.sqrt(d)) / (2*a)
  x2 = (-b - Math.sqrt(d)) / (2*a)
  puts "Ответ: x1 = #{x1}; x2 = #{x2}"
end


