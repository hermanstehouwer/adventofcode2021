ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def validate_one(str, exp) do
    assert exp == SyntaxScoring.match_and_score(
      %SyntaxScoring{},
      String.split(str, "", trim: true),
      []
    )
  end

  test "validate values" do
    [
      {"{([(<{}[<>[]}>{[]{[(<()>", 1197},
      {"[[<[([]))<([[{}[[()]]]", 3},
      {"[{[{({}]{}}([{[{{{}}([]", 57},
      {"[<(<(<(<{}))><([]([]()", 3},
      {"<{([([[(<>()){}]>(<<{{}", 25137},
      {"[({(<(())[]>[[{[]{<()<>>", 0}

    ]
    |> Enum.map(fn {x,y} -> validate_one(x, y) end)
  end

  test "part1_test" do
    a = "[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> SyntaxScoring.match_and_score(
      %SyntaxScoring{},
      String.split(x, "", trim: true),
      [])
      end)
    |> Enum.sum()
    assert a == 26397
  end

  test "closing scores" do
    s = String.split("}}]])})]", "", trim: true)
    assert SyntaxScoring.closing_score(s, 0) == 288957

    s = String.split(")}>]})", "", trim: true)
    assert SyntaxScoring.closing_score(s, 0) == 5566

    s = String.split("}}>}>))))", "", trim: true)
    assert SyntaxScoring.closing_score(s, 0) == 1480781

    s = String.split("]]}}]}]}>", "", trim: true)
    assert SyntaxScoring.closing_score(s, 0) == 995444

    s = String.split("])}>", "", trim: true)
    assert SyntaxScoring.closing_score(s, 0) == 294
  end
end
