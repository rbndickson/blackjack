# blackjack.rb

# 1. Both player and dealer are dealt 2 cards.
#    2 - 9 are worth their value. J, Q, K are 10, A is 1 or 11.

# 2. Player can choose 'hit' or 'stay'.

# 3. If 'hit' player gets another card
# 4. If the sum of the cards > 21 the player has busted.
#    If sum is 21 the player wins.
#    If sum is < 21 the player chooses to hit or stay again (and repeat above).

# 3. If 'stay' the players score is saved and it is the dealers turn.

# 5. Dealer must hit until she has 17 or over.
#    If the dealer busts the player wins.
#    If the dealer hits 21 the dealer wins.
#    If the dealer stays we compare the sums and the highest value wins.

require 'pry'

def initialize_game_data
  game_data = { player: { hand: [], score: 0 },
                dealer: { hand: [], score: 0 },
                deck: %w(AH 2H 3H 4H 5H 6H 7H 8H 9H 10H JH QH KH
                         AD 2D 3D 4D 5D 6D 7D 8D 9D 10D JD QD KD
                         AC 2C 3C 4C 5C 6C 7C 8C 9C 10C JC QC KC
                         AS 2S 3S 4S 5S 6S 7S 8S 9S 10S JS QS KS) }

  values = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,
            11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,
            11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,
            11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]

  # adds a hash of the cards and their values to game_data
  game_data[:card_values] = Hash[game_data[:deck].zip values]
  game_data
end

def initial_deal(game_data)
  deal_card(game_data, :dealer)
  deal_card(game_data, :player)
  deal_card(game_data, :dealer)
  deal_card(game_data, :player)
end

def emoji_sub(card)
  card = card.gsub('H', "\xE2\x99\xA5")
  card = card.gsub('D', "\xE2\x99\xA6")
  card = card.gsub('C', "\xE2\x99\xA3")
  card.gsub('S', "\xE2\x99\xA0")
end

def draw_board(game_data)
  system 'clear'
  dealer_card_string = ' Dealer  '
  player_card_string = ' Player  '

  game_data[:dealer][:hand].each do |card|
    dealer_card_string << emoji_sub(card) + ' '
  end

  game_data[:player][:hand].each do |card|
    player_card_string << emoji_sub(card) + ' '
  end

  puts ''
  puts dealer_card_string
  puts ''
  puts player_card_string
  puts ''
  puts "Dealer has #{game_data[:dealer][:score]}"
  puts "Player has #{game_data[:player][:score]}"
end

def deal_card(game_data, person)
  card_dealt = game_data[:deck].sample
  game_data[:deck].delete(card_dealt)
  game_data[person][:hand] << card_dealt
  update_total(game_data, person)
  draw_board(game_data)
end

def update_total(game_data, person)
  sum = 0
  game_data[person][:hand].each { |card| sum += game_data[:card_values][card] }

  if game_data[person][:hand].to_s.include?("A") && sum > 21
    sum = sum - 10
  end
  
  game_data[person][:score] = sum
end

def hit_or_stay
  puts 'Hit (h) or stay (s) ?'
  gets.chomp.downcase
end

def players_score
  game_data[:player][:score]
end

def players_turn(game_data)
  while game_data[:player][:score] < 21 && hit_or_stay == 'h'
    deal_card(game_data, :player)
  end
  game_data[:player][:score]
end

def dealers_turn(game_data)
  while game_data[:dealer][:score] < 17
    deal_card(game_data, :dealer)
  end
end

def comparison(game_data)
  if game_data[:player][:score] > game_data[:dealer][:score]
    puts 'You win!'
  elsif game_data[:player][:score] < game_data[:dealer][:score]
    puts 'Dealer wins!'
  else
    puts "It's a draw!"
  end
end

def one_game
  game_data = initialize_game_data
  initial_deal(game_data)

  if game_data[:player][:score] == 21
    puts 'You win!'

  else

    players_turn(game_data)
    if game_data[:player][:score] > 21
      puts 'You have busted Dealer wins!'
    elsif game_data[:player][:score] == 21
      puts 'You win!'
    else

      dealers_turn(game_data)
      if game_data[:dealer][:score] < 21
        comparison(game_data)
      elsif game_data[:dealer][:score] == 21
        puts 'Dealer wins!'
      elsif game_data[:dealer][:score] > 21
        puts 'Dealer has busted - You win!'
      end

    end
  end
end

system 'clear'
puts 'Blackjack 0.1!'

loop do
  one_game
  puts 'Play again? (y/n)'
  break if gets.chomp.downcase == 'n'
end

puts 'Thank you for playing Blackjack'
