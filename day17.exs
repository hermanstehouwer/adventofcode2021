# Input: target area: x=179..201, y=-109..-63
x1=179
x2=201
y1=-109
y2=-63

#part 1:
IO.inspect round(y1*(y1-1)/2)

#part 2:
defmodule Shot do
  def in_target(xp,yp,_xv,_yv,x1,x2,y1,y2) when xp in x1..x2 and yp in y1..y2, do: true
  def in_target(xp,yp,_xv,_yv,_x1,x2,y1,_y2) when xp > x2 or yp < y1, do: false
  def in_target(xp,yp,0,yv,x1,x2,y1,y2), do: in_target(xp, yp+yv, 0, yv-1, x1, x2, y1, y2)
  def in_target(xp,yp,xv,yv,x1,x2,y1,y2), do: in_target(xp+xv, yp+yv, xv-1, yv-1, x1, x2, y1, y2)
end
for xv <- 1..x2, yv <- y1..(1-y1) do Shot.in_target(0,0,xv,yv,x1,x2,y1,y2) end
|> Enum.count(&(&1)) |> IO.inspect()
