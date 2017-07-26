require 'benchmark'

def snake_to_camel_gsub(snaked_word)
    str = snaked_word
    str.gsub!(/(\A[a-z])/) { |m| m.upcase }
    str.gsub!(/_[a-z]/,) { |m| m[-1].upcase }
    # str.tr!("_","")
    str
end

def snake_to_camel_join(snaked_word)
    snaked_word.tr("_", " ").split(" ").map { |word| word.capitalize }.join ''
end

# tests

# puts snake_to_camel_gsub("well_hello_jim")
# puts snake_to_camel_join("well_hello_jim")

string1 = "a_hello_my_good_man_howitzer_extreme_plausibility_to_the_great_woman_he_is"
string2 = "a_hello_my_good_man_howitzer_extreme_plausibility_to_the_great_woman_he_is"

puts snake_to_camel_gsub(string1)
puts snake_to_camel_join(string2)

Benchmark.bmbm do |x|
  x.report("gsub") { snake_to_camel_gsub(string1) }
  x.report("join")  { snake_to_camel_join(string2)  }
end
