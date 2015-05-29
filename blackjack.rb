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


deck = ['AH', '2H', '3H', '4H', '5H', '6H', '7H', '8H', '9H', 'JH', 'QH', 'KH',
        'AD', '2D', '3D', '4D', '5D', '6D', '7D', '8D', '9D', 'JD', 'QD', 'KD',
        'AC', '2C', '3C', '4C', '5C', '6C', '7C', '8C', '9C', 'JC', 'QC', 'KC',
        'AS', '2S', '3S', '4S', '5S', '6S', '7S', '8S', '9S', 'JS', 'QS', 'KS']

dealer_display = " Dealer  "
player_display = " Player  "

def draw_board(play_s, dealer_display, player_display)
  puts ''
  puts dealer_display
  puts ''
  puts player_display
  puts ''
end

play_state = {}
system 'clear'
puts 'Blackjack 0.1!'
draw_board(play_state, dealer_display, player_display)
