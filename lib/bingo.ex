defmodule BingoCard do
  defstruct card: Nil,
            numbers_called: [],
            bingo: false

  @type bingocard_type :: list(list(integer()))

  @type t :: %__MODULE__{
    card: bingocard_type,
    numbers_called: list(integer()),
    bingo: boolean()
  }

  @spec draw(BingoCard.t(), integer())::BingoCard.t()
  def draw(bingo_card, number)

  def draw(card, number) do
    %{card | numbers_called: card.numbers_called ++ [number]}
  end

  def str_to_ints(list) do
    Enum.map(list, &String.to_integer/1)
  end

  @spec init(list(String.t()))::BingoCard.t()
  def init(input) do
    card = input |> Enum.map(&String.split(&1, " ", trim: true)) |> Enum.map(&str_to_ints/1)
    %BingoCard{card: card}
  end

  def transpose([[] | _]), do: []
  def transpose(m) do
    [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
  end

  @spec empty_row(bingocard_type(), list(integer()))::boolean()
  def empty_row(rows, numbers) do
    length(
      rows
      |> Enum.map(&Enum.filter(&1, fn x -> !(x in numbers) end))
      |> Enum.filter(fn x -> x == [] end)
      ) > 0
  end

  @spec calc_bingo(BingoCard.t())::BingoCard.t()
  def calc_bingo(card) do
    have_bingo = empty_row(card.card, card.numbers_called)
      or empty_row(transpose(card.card), card.numbers_called)
    %{card | bingo: have_bingo}
  end

  @spec is_bingo(BingoCard.t())::boolean()
  def is_bingo(card) do
    card.bingo
  end

  @spec calc_score(BingoCard.t())::integer()
  def calc_score(card) do
    sum = List.flatten(card.card)
      |> Enum.filter(fn x -> !(x in card.numbers_called) end)
      |> Enum.sum()
    sum * List.last(card.numbers_called)
  end
end

defmodule BingoGame do
  defstruct cards: [],
            bingo: false,
            find_last: false,
            numbers: []

  @type t :: %__MODULE__{
    cards: list(BingoCard),
    bingo: boolean(),
    find_last: boolean(),
    numbers: list(Integer)
  }

  def filter_cards(cards, find_last)

  def filter_cards(cards, false) do
    cards
  end

  def filter_cards([card], true) do
    [card]
  end

  def filter_cards(cards, true) do
    Enum.filter(cards, fn x -> !(BingoCard.is_bingo(x)) end)
  end

  def determine_bingo(cards, find_last)

  def determine_bingo(cards, false) do
    length(Enum.filter(cards, fn x -> BingoCard.is_bingo(x) end)) > 0
  end

  def determine_bingo(cards, true) do
    length(cards) == 1 and BingoCard.is_bingo(List.first(cards))
  end


  @spec draw(integer(), BingoGame.t())::BingoGame.t()
  def draw(number, game) do
    cards = Enum.map(game.cards, &BingoCard.draw(&1, number))
    |> Enum.map(&BingoCard.calc_bingo/1)
    |> filter_cards( game.find_last)
    have_bingo = determine_bingo(cards, game.find_last)
    %{game |
      cards: cards,
      bingo: have_bingo
    }
  end

  @spec play(integer(), BingoGame.t())::BingoGame.t()
  def play(number, game) do
    case game.bingo do
      true -> game
      false -> draw(number, game)
    end
  end

  @spec run_game(BingoGame.t())::integer()
  def run_game(game) do
    Enum.reduce(game.numbers, game, &BingoGame.play/2)
    |> BingoGame.find_winner()
    |> BingoCard.calc_score()
  end

  @spec find_winner(BingoGame.t())::BingoCard.t()
  def find_winner(game) do
    [item] = Enum.filter(game.cards, fn x -> x.bingo end)
    item
  end
end
