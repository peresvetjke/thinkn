#-------Task 1-------

months = { January: 31, February: 28, March: 31, April: 30, May: 31, June: 30, 
           July: 31, August: 31, September: 30, October: 31, November: 30, December: 31}

months.each { |k, v| puts k if v == 30}

#-------Task 2-------

arr = []
i = 10

while i <= 100 do
  arr << i
  i += 5
end

p arr

#-------Task 3-------

fib = [0,1]
i = 2

loop do
  fib << fib[i-2] + fib[i-1]
  break if fib[i] >= 100
  i += 1
end
fib.pop

p fib

#-------Task 4-------

vowel_hash = Hash.new

i = 1
('a'..'z').each do |l| 
  vowel_hash[l] = i if ['a','e','i','o','u','y'].include? (l)
  i += 1
end

p vowel_hash
