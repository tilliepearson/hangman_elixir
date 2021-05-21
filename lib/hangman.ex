defmodule Hangman do 
  alias Hangman.Game

  def game do
    state = Game.init
    IO.puts("Your game has begun. You have #{state.max_guesses} to guess a #{Enum.count(state.word)} letter word")
    play(state)
  end


  defp play(state) do
    guess = IO.read(:stdio, :line) |> String.replace("\n", "")
    {state, guess_response} = Game.guess(state, guess)

    case guess_response do
      :game_over ->
        IO.puts("Game over. Your word was #{state.word}.")

      :game_pending ->
        IO.puts("You have #{Game.guesses_remaining(state)} turns remaining to guess a #{Enum.count(state.word)} letter word")
        IO.puts("#{List.to_string(Game.display_total_guessed_word(state))}")
        play(state)

      :ok ->
        IO.puts("You guessed #{state.word} in #{state.total_guesses} turns")
    end
  end


end
