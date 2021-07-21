puts "Please enter date:"
print "Year = "
year = gets.chomp.to_i
print "Month = "
month = gets.chomp.to_i
print "Day = "
day = gets.chomp.to_i

months_days = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
months_days[1] += 1 if (year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0))

p months_days.take(month-1).sum + day

