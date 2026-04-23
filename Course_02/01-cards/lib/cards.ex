defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling deck of cards
  """

  @doc """
  Create a deck of cards

  ## Example
      iex> Cards.create_deck()
      ["One of Spades", "Two of Spades", "Three of Spades", "Four of Spades",
      "Five of Spades", "One of Clubs", "Two of Clubs", "Three of Clubs",
      "Four of Clubs", "Five of Clubs", "One of Hearts", "Two of Hearts",
      "Three of Hearts", "Four of Hearts", "Five of Hearts", "One of Diamond",
      "Two of Diamond", "Three of Diamond", "Four of Diamond", "Five of Diamond"]
  """

  def create_deck() do
    values = ["One", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamond"]
    # [WARNING] cada laço de repetição do for é armazenado em um array diferente
    for suit <- suits, value <- values do
        "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
  Determines whether a deck cointains given a card

  ## Example
      iex> deck = Cards.create_deck()
      iex> Cards.contains?(deck, "One of Spades")
      true
  """

  def contains?(deck, card) do
    Enum.member?(deck,card)
  end

  @doc """
  Divides a deck into a hand and the remainder of the deck.
  The `hand_size` argument indicates how many cards should be in the hand.

  ## Example
      iex> deck = Cards.create_deck()
      iex> {hand, _deck} = Cards.deal(deck, 1)
      iex> hand
      ["One of Spades"]
  """

  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term binary
      {:error, _reason} -> "That file does not exist"
    end
  end

  def create_hand(hand_size) do
    create_deck()
      |> shuffle()
      |> deal(hand_size)
      |> save("teste")
  end
end
