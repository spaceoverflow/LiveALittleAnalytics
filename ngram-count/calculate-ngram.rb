require 'json'
require_relative 'ngram_helper'
include NgramHelper

msgs = JSON.parse File.read('live-a-little.json')

person_to_msg_map = {}
msgs.each_with_index do |msg, i|
  if msg['text']
    unless msg['from'] and msg['from']['print_name']
      raise 'LOL????'
    end
    person_to_msg_map[msg['from']['print_name']]||=''
    person_to_msg_map[msg['from']['print_name']] = "#{person_to_msg_map[msg['from']['print_name']]}#{msg['text']}\n"
  end
  if (i+1) % 1000 == 0
    puts i+1
  end
end

tokenize_messages!(person_to_msg_map)

# all_msgs = []
# person_to_msg_map.each do |_, msgs|
#   msgs.each do |msg|
#     all_msgs << msg
#   end
# end


person_to_msg_map.each do |name, all_msgs|
  puts "#{name}"
  name.length.times { print '-' }
  puts ''
  for ngram_n in 1..4 do
    sorted_ngrams = get_most_common_ngrams(all_msgs, ngram_n)[0..9]
    puts "#{ngram_n}-gram"
    puts '------'

    sorted_ngrams.each_with_index do |ngram, i|
      puts "#{i+1}. #{ngram[0].reduce("") { |str, w| "#{str}#{w} " }}(#{ngram[1]})"
    end
  end
end


puts 'Done'