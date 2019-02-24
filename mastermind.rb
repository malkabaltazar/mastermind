class Codemaker
  def make
    @code = [1 + rand(6), 1 + rand(6), 1 + rand(6), 1 + rand(6)]
  end

  def user_make
    puts 'Choose four digits between 1 and 6 separated by ", ".'
    @code = gets.chomp.split(", ")
    # Add an if clause to ascertain the code is valid.
  end

  def feedback(guess)
    @guess = guess
    @response = []
    bulls
    cows
    for x in (0..3) do
      if @response[x] == nil
        @response[x] = "·"
      end
    end
    puts "#{@guess} #{@response.join}"
    return @response
  end

  def reveal
    puts "You lose. Code was #{@code}."
  end

  private

  def bulls
    @copycode = []
    @code.each { |num| @copycode.push(num.to_i) }
    @copyguess = []
    @copyguess.replace(@guess)
    [3, 2, 1, 0].each do |x|
      if @guess[x].to_i == @code[x].to_i
        @response.push("•") #☻
        # Remove matches from array so they are not counted twice.
        @copyguess.delete_at(x)
        @copycode.delete_at(x)
      end
    end
  end

  def cows
    @copyguess.each do |x|
      if @copycode.include? x.to_i
        @response.push("°") #o
        match = @copycode.index(x.to_i)
        @copycode[match] = "n"
      end
    end
  end
end

class Codebreaker
  def user_guess # Maybe refractor to work for both comp and user.
    maker = Codemaker.new
    maker.make
    puts 'Guess four digits between 1 and 6 separated by ", ".'
    i = 0
    while i < 12 do
      i += 1
      guess = gets.chomp.split(", ")
      if maker.feedback(guess) == ["•", "•", "•", "•"]
        puts "You win!"
        Game.new_game
      end
    end
    maker.reveal
    Game.new_game
  end

  def comp_guess
    user = Codemaker.new
    user.user_make
    guess1 = []
    for x in (1..5) do
      guess2 = [x, x, x, x]
      response = user.feedback(guess2)
      number = response.count("•")
      number.times do
        guess1.push(x)
      end
    end
    for x in (0..3) do
      if guess1[x] == nil
        guess1[x] = 6
      end
    end
    i = 0
    while i < 7
      i += 1
      if user.feedback(guess1) == ["•", "•", "•", "•"]
        puts "You lose."
        Game.new_game
      end
      guess1.shuffle!
    end
    puts "You win!"
    Game.new_game
  end
end

class Game
  def self.play
    puts "Would you like to be the code-maker or the code-breaker? (m/b)"
    response = gets.chomp
    if response == "b"
      breaker = Codebreaker.new
      breaker.user_guess
    elsif response == "m"
      breaker = Codebreaker.new
      breaker.comp_guess
    else
      puts "Please type 'm' or 'b'."
      Game.play
    end
  end

  def self.new_game
    puts "Would you like to play again? (y/n)"
    if gets.chomp == "y"
      Game.play
    else
      exit
    end
  end
end

puts "Hey there! Welcome to mastermind!"
Game.play
