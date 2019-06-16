require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def check_the_word
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    user_serialized = open(url).read
    result = JSON.parse(user_serialized)
    result['found']
  end

  def score
    @word = params[:word]
    session[:points] = 0
    @points = 0
    @score = params[:word].split('')
    @score.each do |letter|
      if !params[:grid].split('').include?(letter.upcase)
        @answer = "Sorry but <strong>
        #{params[:word].upcase}</strong> cannot be build out of
        #{params[:grid].split('').join(', ')}".html_safe
      else
        if check_the_word
          @answer = "<strong>Congratulations
            </strong>, #{params[:word].upcase} is a valid English word!".html_safe
          @points = @word.size
          session[:points] += @word.size
        else
          @answer = "Sorry but <strong>#{params[:word].upcase}
            </strong> doesn't seem to be a valid english word".html_safe
        end
      end
    end
  end
end
