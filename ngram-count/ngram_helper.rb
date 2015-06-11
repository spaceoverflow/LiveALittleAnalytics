require 'open3'
require 'facets'

module NgramHelper
  def get_ngrams(messages, n)
    grams = []
    messages.each do |tokens|
      tokens.each_with_index do |_, i|
        if tokens.length >= i+n # we need to be able to make this n-gram
          gram =[]
          (i..i+n-1).each { |ix|
            gram << tokens[ix]
          }
          grams << gram
        end
      end
    end
    grams
  end

  def get_most_common_ngrams(sentences, n=2)
    get_ngrams(sentences, n).frequency.sort_by(&:last).reverse
  end

# Downcase tokens and throw away tokens with no letters
  def normalize_tokens(tokens)
    tokens.reduce([]) { |rest, el|
      if el.match /\p{L}+/
        rest << el.downcase
      end
      rest
    }
  end

# Use Alpino to tokenize the messages
  def tokenize_messages!(person_to_msg_map)
    person_to_msg_map.each do |name, txt|
      o, e, s = Open3::capture3('$ALPINO_HOME/Tokenization/paragraph_per_line | $ALPINO_HOME/Tokenization/tokenize.sh',
                                :stdin_data => txt)
      if e and e.length > 0
        raise "#{s}: #{e}"
      end

      tokenized_lines=[]
      o.each_line do |line|
        tokens = normalize_tokens(line.split(' '))
        tokenized_lines << tokens
      end
      person_to_msg_map[name] = tokenized_lines
      puts "Tokenized #{name}"
    end
  end

end