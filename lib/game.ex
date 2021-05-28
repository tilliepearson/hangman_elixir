defmodule Hangman.Game do
  defstruct max_guesses: 0, total_guesses: 0, word: [], guessed_letters: []

  def init do
    %Hangman.Game{max_guesses: 10, total_guesses: 0, word: generate_word(), guessed_letters: []}
  end

  def generate_word do
    Dictionary.random_word() |> String.codepoints()
  end

  def guesses_remaining(state) do
    state.max_guesses - state.total_guesses
  end

  def guess(state, guess) do
    state = add_guess_to_guessed_letters(state, guess)
    {state, game_status(state)}
  end

  def increment_guesses(new_letters, state) do
    if Enum.sort(new_letters) == Enum.sort(state.guessed_letters) do
      %{state | total_guesses: state.total_guesses + 1}
    else
      %{state | guessed_letters: new_letters}
    end
  end

  def game_status(state) do
    cond do
      List.to_string(state.word) == display_total_guessed_word(state) ->
        :ok

      guesses_remaining(state) === 0 ->
        :game_over

      true ->
        :game_pending
    end
  end

  def match_guessed_letter(state, guess) do
    Enum.map(state.word, fn letter ->
      if guess == letter, do: letter
    end)
    |> Enum.filter(&(!is_nil(&1)))
  end

  def add_guess_to_guessed_letters(state, guess) do
    (state.guessed_letters ++ match_guessed_letter(state, guess))
    |> Enum.uniq()
    |> increment_guesses(state)
  end

  def display_total_guessed_word(state) do
    Enum.map(state.word, fn letter ->
      if Enum.member?(state.guessed_letters, letter), do: letter, else: "_"
    end)
    |> List.to_string()
  end
end
