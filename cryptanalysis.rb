class Cryptanalysis
  ALPHABET = ('A'..'Z').to_a.join

  ENGLISH_FREQUENCY = { A: 0.080, B: 0.015, C: 0.030, D: 0.040, E: 0.130, F: 0.020,
                        G: 0.015, H: 0.060, I: 0.065, J: 0.005, K: 0.005, L: 0.035,
                        M: 0.030, N: 0.070, O: 0.080, P: 0.020, Q: 0.002, R: 0.065,
                        S: 0.060, T: 0.090, U: 0.030, V: 0.010, W: 0.015, X: 0.005,
                        Y: 0.020, Z: 0.002 }

  def Cryptanalysis.caesar_cipher(text, shift, mode = :encrypt)
    text      = text.upcase
    shift     = shift % ALPHABET.size
    decrypt   = ALPHABET
    encrypt   = ALPHABET[shift..-1] + ALPHABET[0...shift]

    text.tr(mode == :decrypt ? encrypt : decrypt,
            mode == :decrypt ? decrypt : encrypt) #ciphertext/plaintext
  end

  def Cryptanalysis.vigenere_cipher(text, key, mode = :+)
    text = text_to_char_array(text).join #Eliminate unwanted symbols
    i = 0
    text.upcase.each_byte.reduce('') { |r, c|
      r << (65 + (c.send(mode, key[i % key.length].ord)) % ALPHABET.size).chr
      i += 1
      r
    }
  end

  def Cryptanalysis.analyze_caesar(ciphertext)
    ciphertext_frequency      = character_frequency(ciphertext, :frequency)
    correlation_of_frequency  = {}

    (0..25).each { |i| #Potential shift amount
      frequency = 0.0
      ALPHABET.each_char { |c| frequency += ciphertext_frequency[c.to_sym] *
                                        ENGLISH_FREQUENCY[ALPHABET[(ALPHABET.size + ALPHABET.index(c) - i) %
                                                     ALPHABET.size].to_sym] }

      correlation_of_frequency[i] = frequency
    }

    correlation_of_frequency.sort_by { |_, v| -v }.take(5).to_h #Top 5 results
  end

  def Cryptanalysis.compute_ic(ciphertext)
    chars       = text_to_char_array(ciphertext)
    occurrence  = character_frequency(ciphertext, :occurrence)

    sum = 0.0
    ALPHABET.each_char { |c|
      f_i = occurrence[c.to_sym]
      sum += f_i * (f_i - 1.0)
    }
    n = chars.size

    sum /= n * (n - 1.0)

    sum
  end

  def Cryptanalysis.text_to_char_array(text)
    result = text.upcase
    result.gsub(/[^A-Z]/i, '').split(//)
  end
  private_class_method :text_to_char_array

  def Cryptanalysis.character_frequency(ciphertext, mode = :occurrence)
    chars     = text_to_char_array(ciphertext)
    default   = ENGLISH_FREQUENCY.map{|k,_| [k, 0]}.to_h
    freqs     = chars.group_by {|c| c}
                    .map {|k,v| [k.to_sym, v.size.to_f / ((mode == :occurrence) ? 1.0 : chars.size)]}
                    .to_h
    default.merge(freqs)
  end
end