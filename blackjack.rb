# blackjack.rb

def initialize_game_data(player_name)
  game_data = { player: { name: player_name, hand: [], score: 0 },
                dealer: { name: 'Dealer', hand: [], score: 0 },
                turn: 'Player',
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
  2.times do
    deal_card(game_data, :player)
    deal_card(game_data, :dealer)
  end
end

def initial_blackjack(game_data)
  game_data[:turn] = 'Dealer'
  draw_board(game_data)
  if game_data[:dealer][:score] == 21
    puts "Push"
  else
    puts "You win with Blackjack!"
  end
end

def emoji_sub(card)
  card = card.gsub('H', "\xE2\x99\xA5")
  card = card.gsub('D', "\xE2\x99\xA6")
  card = card.gsub('C', "\xE2\x99\xA3")
  card.gsub('S', "\xE2\x99\xA0")
end

def generate_display_string(game_data, person)
  spacing = 20 - game_data[person][:name].length
  spacing_string = ""
  spacing.times { spacing_string << " " }
  display_string = " #{game_data[person][:name]}#{spacing_string}"
  game_data[person][:hand].each do |card|
    display_string << emoji_sub(card) + ' '
  end
  display_string
end

def draw_board(game_data)
  sleep 1.5
  system 'clear'
  dealer_card_string = generate_display_string(game_data, :dealer)
  dealer_card_string[21..22] = '**' if game_data[:turn] == 'Player'
  player_card_string = generate_display_string(game_data, :player)
  puts "\n#{dealer_card_string}\n\n#{player_card_string}\n\n"
end

def deal_card(game_data, person)
  card_dealt = game_data[:deck].sample
  game_data[:deck].delete(card_dealt)
  game_data[person][:hand] << card_dealt
  update_total(game_data, person)
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
  accepted_answers = ['h', 's']
  puts 'Hit (h) or stay (s) ?'
  answer = gets.chomp.downcase
  until accepted_answers.include?(answer)
    puts 'Please re-enter - Hit (h) or stay (s) ?'
  end
  answer
end

def players_turn(game_data)
  while game_data[:player][:score] < 22 && hit_or_stay == 'h'
    deal_card(game_data, :player)
    draw_board(game_data)
  end
  game_data[:player][:score]
end

def dealers_turn(game_data)
  draw_board(game_data)
  while game_data[:dealer][:score] < 17
    deal_card(game_data, :dealer)
    draw_board(game_data)
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

def one_game(player_name)
  game_data = initialize_game_data(player_name)
  initial_deal(game_data)
  draw_board(game_data)
  if game_data[:player][:score] == 21
    game_data[:turn] = 'Dealer'
    draw_board(game_data)
    if game_data[:dealer][:score] == 21
      puts "Push"
    else
      puts "You win with Blackjack!"
    end
  else
    players_turn(game_data)
    if game_data[:player][:score] > 21
      puts 'You have busted Dealer wins!'
    else
      game_data[:turn] = 'Dealer'
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
puts 'Enter player name:'
player_name = gets.chomp

loop do
  one_game(player_name)
  puts 'Play again? (y/n)'
  break if gets.chomp.downcase == 'n'
end

puts 'Thank you for playing Blackjack'
