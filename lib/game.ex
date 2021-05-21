defmodule Hangman.Game do
  defstruct max_guesses: 0, total_guesses: 0, word: [], guessed_letters: []

  def init do
   %Hangman.Game{max_guesses: 10, total_guesses: 0, word: generate_word(), guessed_letters: []}
  end

  def increment_guesses(state) do
   %{ state | total_guesses: state.total_guesses + 1}
  end

  def guesses_remaining(state) do state.max_guesses - state.total_guesses end

  def game_status(state) when state.guessed_letters === state.word, do: :ok
  def game_status(state) when state.max_guesses - state.total_guesses === 0, do: :game_over
  def game_status(_state), do: :game_pending

 
  def add_guess_to_guessed_letters(state, guess) do
     bar = String.codepoints(guess)
     
    new_guessed_letters = Enum.map(state.word, fn letter -> 
      if Enum.member?(bar, letter) do
       letter
      end
    end) |> Enum.filter(& !is_nil(&1))

   %{ state | guessed_letters: state.guessed_letters ++ new_guessed_letters }
    
  end

  def display_total_guessed_word(state) do
    Enum.map(state.word, fn letter -> 
      if Enum.member?(state.guessed_letters, letter) do
        letter
      else
        "_"
      end
    end) 
  end

  def guess(state, guess) do
    guess = String.trim(guess) |> String.downcase()
    state = increment_guesses(state) |> add_guess_to_guessed_letters(guess)
    IO.inspect(state.guessed_letters)
    IO.inspect(state.word)
    {state, game_status(state)}
  end

  def generate_word do
     Dictionary.random_word() |> 
     String.codepoints
  end
end