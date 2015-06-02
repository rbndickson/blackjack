# blackjack.rb

def initialize_game_data(player_name)
  suits = %w(H D C S)
  card_types = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  deck_array = card_types.product(suits).map { |arr| arr.join }

  # Creates a hash of all cards and their values
  values = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
  values_array = []
  values.each do |value|
    4.times { values_array << value }
  end

  values_hash = Hash[deck_array.zip values_array]

  game_data = { player: { name: player_name, hand: [], score: 0 },
                dealer: { name: 'Dealer', hand: [], score: 0 },
                turn: 'Player',
                deck: deck_array, card_values: values_hash }

  game_data
end

def initial_deal(game_data)
  2.times do
    deal_card(game_data, :player)
    deal_card(game_data, :dealer)
  end
end

def emoji_sub(card)
  card = card.gsub('H', "\xE2\x99\xA5")
  card = card.gsub('D', "\xE2\x99\xA6")
  card = card.gsub('C', "\xE2\x99\xA3")
  card.gsub('S', "\xE2\x99\xA0")
end

def display_cards(game_data, person)
  spacing = 20 - game_data[person][:name].length
  spacing_string = ''
  spacing.times { spacing_string << ' ' }
  display_string = " #{game_data[person][:name]}#{spacing_string}"
  game_data[person][:hand].each do |card|
    display_string << emoji_sub(card) + '  '
  end

  display_string
end

def draw_board(game_data)
  sleep 1.2
  system 'clear'
  dealer_card_string = display_cards(game_data, :dealer)
  dealer_card_string[21..23] = '***' if game_data[:turn] == 'Player'
  player_card_string = display_cards(game_data, :player)
  puts "\n#{dealer_card_string}\n\n#{player_card_string}\n\n"
end

def deal_card(game_data, person)
  card_dealt = game_data[:deck].sample
  game_data[:deck].delete(card_dealt)
  game_data[person][:hand] << card_dealt
  update_total(game_data, person)
end

def update_total(game_data, person)

  total = game_data[person][:hand].inject(0) do |sum, card|
    sum + game_data[:card_values][card]
  end

  number_aces = 0
  game_data[person][:hand].each do |card|
    number_aces += 1 if card.include?('A')
  end

  while total > 21 && number_aces > 0
    total -= 10
    number_aces -= 1
  end

  game_data[person][:score] = total
end

def hit_or_stay
  puts 'Hit (h) or stay (s) ?'
  answer = gets.chomp.downcase
  until ['h', 's'].include?(answer)
    puts 'Please re-enter - Hit (h) or stay (s) ?'
    answer = gets.chomp.downcase
  end

  answer
end

def players_turn(game_data)
  while game_data[:player][:score] < 22 && hit_or_stay == 'h'
    deal_card(game_data, :player)
    draw_board(game_data)
  end
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
      puts "It's a draw!"
    else
      puts 'You win with Blackjack!'
    end
  else
    players_turn(game_data)
    game_data[:turn] = 'Dealer'
    if game_data[:player][:score] > 21
      puts 'You have busted Dealer wins!'
    else
      dealers_turn(game_data)
      if game_data[:dealer][:score] < 21
        comparison(game_data)
      elsif game_data[:dealer][:score] == 21
        puts 'Dealer wins with Blackjack!'
      elsif game_data[:dealer][:score] > 21
        puts 'Dealer has busted - You win!'
      end
    end
  end
  puts "#{player_name} #{game_data[:player][:score]} vs " \
  "Dealer #{game_data[:dealer][:score]}"
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

puts "Thank you for playing Blackjack #{player_name}."
