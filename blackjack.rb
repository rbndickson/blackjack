# blackjack.rb

# 1. Both player and dealer are dealt 2 cards.
#    2 - 9 are worth their value. J, Q, K are 10, A is 1 or 11.

# 2. Player can choose 'hit' or 'stay'.

# 3. If 'hit' player gets another card
# 4. If the sum of the cards > 21 the player has busted.
#    If sum is 21 the player wins.
#    If sum is < 21 the player chooses to hit or stay again (and repeat above).

# 3. If 'stay' the players score is saved and it is the dealers turn.

# 5. Dealer must hit until she has >= 17.
#    If the dealer busts the player wins.
#    If the dealer hits 21 the dealer wins.
#    If the dealer stays we compare the sums and the highest value wins.

# require 'pry'

game_data = { :player => { :cards => [], :score => 0 },
          :dealer => { :cards => [], :score => 0 },
          :deck => ['AH', '2H', '3H', '4H', '5H', '6H',
                    '7H', '8H', '9H', '10H', 'JH', 'QH', 'KH',
                    'AD', '2D', '3D', '4D', '5D', '6D',
                    '7D', '8D', '9D', '10D', 'JD', 'QD', 'KD',
                    'AC', '2C', '3C', '4C', '5C', '6C',
                    '7C', '8C', '9C', '10C', 'JC', 'QC', 'KC',
                    'AS', '2S', '3S', '4S', '5S', '6S',
                    '7S', '8S', '9S', '10S', 'JS', 'QS', 'KS'] }


values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,]


card_values = Hash[game_data[:deck].zip values]

def draw_board(game_data)
  system 'clear'
  dealer_card_string = " Dealer  "
  player_card_string = " Player  "

  game_data[:dealer][:cards].each do |card|
    dealer_card_string << card + ' '
  end

  game_data[:player][:cards].each do |card|
    player_card_string << card + ' '
  end

  puts ''
  puts dealer_card_string
  puts ''
  puts player_card_string
  puts ''
end


def deal_card(game_data, person)
  card_dealt = game_data[:deck].sample
  game_data[:deck].delete(card_dealt)
  game_data[person][:cards] << card_dealt
  draw_board(game_data)
end

# def update_total(game_data, person)
#   game_data(person) =
# end

def dealers_turn(game_data)

end

def hit_or_stay
  puts 'Hit (h) or stay (s) ?'
  next_move = gets.chomp.downcase
  next_move
end

system 'clear'
puts 'Blackjack 0.1!'

deal_card(game_data, :dealer)
deal_card(game_data, :player)
deal_card(game_data, :dealer)
deal_card(game_data, :player)

def players_turn(game_data)
  while hit_or_stay == 'h'
    deal_card(game_data, :player)
    # check_for_21()
    # check_for_bust()
  end
end

players_turn(game_data)
dealers_turn(game_data)
