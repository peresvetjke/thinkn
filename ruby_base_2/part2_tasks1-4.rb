#-------Task 1-------

months = { January: 31, February: 28, March: 31, April: 30, May: 31, June: 30, 
           July: 31, August: 31, September: 30, October: 31, November: 30, December: 31}

months.each { |month, days| puts month if days == 30}

#-------Task 2-------

arr = []

(10..100).each {|x| arr << x if x % 5 == 0}

p arr

#-------Task 3-------

fib = [0, 1]

loop do
  fib << fib[-2] + fib[-1]
  break if fib.last > 100
end

fib.pop

p fib

#-------Task 4-------

vowel_hash = {}

('a'..'z').each_with_index do |letter, index| 
  vowel_hash[letter] = index + 1 if ['a','e','i','o','u','y'].include? (letter)
end

p vowel_hash
