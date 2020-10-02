require "set"
require_relative "player.rb"

class Game

    LETTERS = Set.new("a".."z")
    LIVES_COUNT = 5

    def initialize(*players)

        words = File.readlines("dictionary.txt").map(&:chomp)
        @dictionary = Set.new(words)
        @fragment = ""
        @losses_count = Hash.new {|losses, player| losses[player] = 0}
        @players = players.map { |name| Player.new(name)}
        @current_player = @players[0]
        @previous_player = nil
        @remaining_players = @players.clone

    end

    def welcome
        puts "Welcome to the GHOST Game!"
        puts "----------------------"
        puts "Players:"
        @players.each {|player| puts player.name}
        puts "----------------------"
    end

    def display_lives
        puts "Remaining lives:"
        @players.each do |player| 
            puts "#{player.name}: #{player.losses}"
        end
        puts "----------------------"
    end

    def run
        system("clear")
        welcome
        play_round until game_over?
        puts "#{winner.name} has won the game!"
        puts "----------------------"
    end

    def game_over?
        @players.one? { |player| player.losses > 0}
    end

    def winner
        winner_arr = @players.select { |player| player.losses > 0}
        winner = winner_arr[0]
    end

    def play_turn
        input, trial = ""
        puts "It's #{@current_player.name}'s turn.'"
        puts "Current word fragment: #{@fragment}"
        puts "Write a letter:"
        while guess_invalid?(input, trial)
            input = gets.chomp.downcase
            trial = @fragment + input
            if guess_invalid?(input, trial)
                puts "Your input is invalid. Please write a letter so that the word fragment potentially makes up a word:"
            else
                @fragment = trial
            end
        end
    end

    def play_round
        until word_found?
            play_turn
            take_turn
        end
        puts "That's a word! #{@previous_player.name} lost a life!"
        puts "----------------------"
        @previous_player.losses -= 1
        @remaining_players.delete(@previous_player) if @previous_player.losses == 0
        @fragment = ""
        display_lives
    end 


    def input_invalid?(input)
        return true unless LETTERS.include?(input)
        false
    end

    def trial_invalid?(trial)
        @dictionary.none? { |word| word.start_with?(trial)}
    end

    def guess_invalid?(input, trial)
        return true if (input_invalid?(input) || trial_invalid?(trial))
        false
    end

    def word_found?
        @dictionary.include?(@fragment)
    end

    def take_turn
        @remaining_players.rotate!
        @previous_player = @current_player
        @current_player = @remaining_players[0]
    end


end

if __FILE__ == $PROGRAM_NAME
    game = Game.new("Jozsi", "Sari", "Vilma", "Geza")

    game.run
end

        