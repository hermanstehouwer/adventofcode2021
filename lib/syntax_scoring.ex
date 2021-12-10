defmodule SyntaxScoring do
  defstruct matches: %{"(" => ")", "[" => "]", "<" => ">", "{" => "}"},
            scores: %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}


  def closing_score(ec, total)

  def closing_score([], total) do
    total
  end

  def closing_score([hd|tl], total) do
    values = %{")" => 1, "]" => 2, "}" => 3, ">" => 4}
    closing_score(tl, total*5 + values[hd])
  end

  # vc: false 0 means incomplete, otherwise returns the value of the syntax error found
  # vc: true 0 means syntax error, otherwise returns the value of the leftover expected_closings
  def match_and_score(scores, subsystem, expected_closing, value_close \\ false)

  # No more to match
  def match_and_score(_scores, [], _ec, false) do
    0
  end

  # No more to match
  def match_and_score(_scores, [], ec, true) do
    closing_score(ec, 0)
  end


  #Open a (
  def match_and_score(scores, [hd|tl], ec, vc) when hd in ["{", "(", "<", "["] do
    exp = scores.matches[hd]
    match_and_score(
      scores,
      tl,
      [exp] ++ ec,
      vc
    )
  end

  # Close a )
  def match_and_score(scores, [hd|tl], [hd|etl], vc) do
      match_and_score(
        scores,
        tl,
        etl,
        vc
      )
  end

  def match_and_score(scores, [hd|_tl], _expected_closing, false) do
    scores.scores[hd]
  end

  def match_and_score(_scores, _subsystem, _expected_closing, true) do
    0
  end
end
