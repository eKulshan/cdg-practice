# frozen_string_literal: true

def word_square(word)
  word[-2, 2] == 'CS' ? 2**word.length : word.reverse
end
