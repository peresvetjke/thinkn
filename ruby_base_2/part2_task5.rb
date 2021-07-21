puts "Please enter date:"
print "Year = "
y = gets.chomp.to_i
print "Month = "
m = gets.chomp.to_i
print "Day = "
d = gets.chomp.to_i

def leap_check(year)
  if year % 400 == 0
    return true
  elsif (year % 4 == 0) && (year % 100 != 0)
    return true 
  else 
    return false
  end
end

def month_days(month,year)
  months_arr = [ [1, 31], [2, 28], [3, 31], [4, 30], [5, 31], [6, 30], [7, 31], [8, 31], [9, 30], [10, 31], [11, 30], [12, 31] ]
  
  if month == 2
    return leap_check(year) ? 29 : 28
  else
    return months_arr[month-1][1]
  end
end

def count_days(day,month,year)
  c = 0
  i = 1

  while i < month
    c += month_days(i,year)
    i+=1
  end
  
  c += day
end

p count_days(d,m,y)
