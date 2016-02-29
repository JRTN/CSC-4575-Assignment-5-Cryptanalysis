require_relative 'cryptanalysis'

def caesar_encrypt
  text = get_input('Enter the name of the file containing the text to encrypt: ', 'Enter the text to encrypt: ')
  shift = get_cmd_entry('Enter the shift key (0-25): ').to_i

  puts "Plaintext: %s\nCiphertext: %s\n" % [text, Cryptanalysis.caesar_cipher(text, shift, :encrypt)]
end

def caesar_decrypt
  text = get_input('Enter the name of the file containing the text to decrypt: ', 'Enter the text to decrypt: ')
  shift = get_cmd_entry('Enter the shift key (0-25): ').to_i

  puts "Ciphertext: %s\nPlaintext: %s\n" % [text, Cryptanalysis.caesar_cipher(text, shift, :decrypt)]
end

def caesar_analyze
  text = get_input('Enter the name of the file containing the text to be analyzed: ', 'Enter the text to be analyzed: ')
  result = Cryptanalysis.analyze_caesar(text).to_a.take(5).to_h

  puts 'Top 5 possible shifts: '
  choice = 0
  result.each { |k, v| puts '%10s) Shift amount: %2s Correlation: %%%.4f Result: %s' % [choice += 1, k, v, Cryptanalysis.caesar_cipher(text, k, :decrypt)] }
end

def compute_ic
  text = get_input('Enter the name of the file containing the text to be analyzed: ', 'Enter the text to be analyzed: ')
  puts "Text: %s\nIC: %.4f" % [text, Cryptanalysis.compute_ic(text)]
end

def compute_occurrence
  text = get_input('Enter the name of the file containing the text to be analyzed: ', 'Enter the text to be analyzed: ')
  puts "Text: %s\nOccurrences: %s" % [text, Cryptanalysis.character_frequency(text, :occurrence)]
end

def compute_frequency
  text = get_input('Enter the name of the file containing the text to be analyzed: ', 'Enter the text to be analyzed: ')
  puts "Text: %s\nFrequencies: %s" % [text, Cryptanalysis.character_frequency(text, :frequency)]
end

def vigenere_encrypt
  text = get_input('Enter the name of the file containing the text to encrypt: ', 'Enter the text to encrypt: ')
  key = get_cmd_entry('Enter the encryption key: ')

  puts "Plaintext: %s\nCiphertext: %s\n" % [text, Cryptanalysis.vigenere_cipher(text, key)]
end

def vigenere_decrypt
  text = get_input('Enter the name of the file containing the text to decrypt: ', 'Enter the text to decrypt: ')
  key = get_cmd_entry('Enter the encryption key): ')

  puts "Ciphertext: %s\nPlaintext: %s\n" % [text, Cryptanalysis.vigenere_cipher(text, key, :-)]
end

def get_input(file_message, cmd_message)
  (get_input_mode == :file) ? get_file_contents(file_message) : get_cmd_entry(cmd_message)
end

def get_input_mode
  puts "Enter how the data will be input:\n1) Command line\n2) Text File"
  user_choice = gets.chomp

  user_choice == '1' ? :cmd : :file
end

def get_file_contents(message)
  puts message
  filename = gets.chomp
  File.open(filename).read
end

def get_cmd_entry(message)
  puts message
  gets.chomp
end

menu = '
1) Encrypt a string with a Caesar cipher
2) Decrypt a Caesar cipher with the key
3) Analyze a Caesar cipher to find the top 5 possible keys
4) Compute the Index of Coincidence for a string
5) Compute the number of times each letter occurs in a string
6) Compute the frequency at which each letter occurs in a string
7) Encrypt a string with a Vigenere cipher
8) Decrypt a Vigenere cipher with the key
0) Quit'

loop = true
while loop
  puts "#####Cryptanalysis Driver#####\n%s" % [menu]
  userchoice = gets.chomp

  case userchoice
    when '1'
      caesar_encrypt
    when '2'
      caesar_decrypt
    when '3'
      caesar_analyze
    when '4'
      compute_ic
    when '5'
      compute_occurrence
    when '6'
      compute_frequency
    when '7'
      vigenere_encrypt
    when '8'
      vigenere_decrypt
    when '0'
      puts 'exiting..'
      loop = false
    else

  end
end


