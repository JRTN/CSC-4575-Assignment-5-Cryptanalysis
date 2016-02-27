class Cryptanalysis
  @@alphabet = ('A'..'Z').to_a.join

  @@english_frequency = { A: 0.080, B: 0.015, C: 0.030, D: 0.040, E: 0.130, F: 0.020,
                          G: 0.015, H: 0.060, I: 0.065, J: 0.005, K: 0.005, L: 0.035,
                          M: 0.030, N: 0.070, O: 0.080, P: 0.020, Q: 0.002, R: 0.065,
                          S: 0.060, T: 0.090, U: 0.030, V: 0.010, W: 0.015, X: 0.005,
                          Y: 0.020, Z: 0.002 }

  def Cryptanalysis.caesar_cipher(text, shift, mode = :encrypt)
    text      = text.upcase
    shift     = shift % @@alphabet.size
    decrypt   = @@alphabet
    encrypt   = @@alphabet[shift..-1] + @@alphabet[0...shift]

    text.tr(mode == :decrypt ? encrypt : decrypt,
            mode == :decrypt ? decrypt : encrypt) #ciphertext/plaintext
  end

  def Cryptanalysis.vigenere_cipher(text, key, mode = :+)
    text = text_to_char_array(text).join #Eliminate unwanted symbols
    i = 0
    text.upcase.each_byte.reduce('') do |r, c|
      r << (65 + (c.send(mode, key[i % key.length].ord)) % 26).chr
      i += 1
      r
    end
  end

  def Cryptanalysis.analyze_caesar(ciphertext)
    ciphertext_frequency      = character_frequency(ciphertext, :frequency)
    correlation_of_frequency  = {}

    (0..25).each { |i| #Potential shift amount
      frequency = 0.0
      @@alphabet.each_char { |c| frequency += ciphertext_frequency[c.to_sym] * @@english_frequency[@@alphabet[(26 + @@alphabet.index(c) - i) % 26].to_sym] } #Correlation of frequency formula

      correlation_of_frequency[i] = frequency
    }

    correlation_of_frequency.sort_by { |_, v| -v }.take(5).to_h #Top 5 results
  end

  def Cryptanalysis.compute_ic(ciphertext)
    chars       = text_to_char_array(ciphertext)
    occurrence  = character_frequency(ciphertext, :occurrence)

    sum = 0.0
    @@alphabet.each_char { |c|
      f_i = occurrence[c.to_sym]
      sum += f_i * (f_i - 1.0)
    }
    n = chars.size

    sum /= n * (n - 1.0)

    sum
  end

  def Cryptanalysis.text_to_char_array(text)
    result = text.upcase
    result = result.gsub(/[^A-Z]/i, '').split(//)

    result #Array of only uppercase alphabetical chars of the text
  end
  private_class_method :text_to_char_array

  def Cryptanalysis.character_frequency(ciphertext, mode = :occurrence)
    chars = text_to_char_array(ciphertext)
    frequency = {}
    increment = (mode == :frequency) ? 1.0 / chars.size : 1.0

    @@alphabet.each_char  { |c| frequency[c.to_sym] = 0.0 }
    chars.each            { |c| frequency[c.to_sym] += increment }

    frequency
  end
end
