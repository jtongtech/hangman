require 'sinatra'
require 'rubygems'
require_relative 'hangman_class.rb'

enable :sessions


get '/' do
    erb :enter_word
end

post '/word' do
    word = params[:word] #because i am not doing anything with it going forward
    session[:game] = Hangman.new(word) #this gives me access to all the methods and variable in hangman class
    # guessed_letters = params[:letter_guess]
    redirect '/player_2_name'
end

get '/player_2_name' do
    erb :player_2_name
end

post '/player_2_name' do
	session[:player_2_name] = params[:player_2]
    erb :player_2_name
    redirect '/play_game'
end

get '/play_game' do
    erb :play_game, :locals => {:guessed_letters => session[:game].guessed_letters, :blank_word => session[:game].blank_word}
    #the above gives you access to guessed_letters and blank_word, these point to the hangman class.rb and make them able to pass to the views
end

post '/letter_guess' do
  letter_guess = params[:letter_guess]
  session[:game].guess(letter_guess)
  puts session[:game].chances
  if session[:game].no_empty_strings_left?(session[:blank_word])
      redirect '/winner'
  elsif session[:game].chances >= 7
      redirect '/game_over'
  else
      redirect '/play_game'
  end
end

get '/game_over' do
    word = session[:game].word
    erb :game_over, :locals => {:guessed_letters => session[:game].guessed_letters, :word => session[:game].word}
end

get '/winner' do
    word = session[:game].word
    erb :winner, :locals => {:guessed_letters => session[:game].guessed_letters, :word => session[:game].word}
end

