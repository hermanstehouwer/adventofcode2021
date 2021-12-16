defmodule Packet do
  defstruct version: Nil, id: Nil, value: 0, children: []
  @type t :: %__MODULE__{version: integer(), id: integer(), value: integer(), children: [Packet.t()]}

  @spec b_to_i(boolean())::integer()
  def b_to_i(b)
  def b_to_i(true), do: 1
  def b_to_i(false), do: 0

  @spec add_version(Packet.t())::integer()
  def add_version(packet), do: packet.version + Enum.sum(Enum.map(packet.children, &add_version/1))

  @spec calculate_value(Packet.t())::integer()
  def calculate_value(packet)
  def calculate_value(%Packet{id: 0, children: children}), do: Enum.sum(Enum.map(children, &calculate_value/1))
  def calculate_value(%Packet{id: 1, children: children}), do: Enum.product(Enum.map(children, &calculate_value/1))
  def calculate_value(%Packet{id: 2, children: children}), do: Enum.min(Enum.map(children, &calculate_value/1))
  def calculate_value(%Packet{id: 3, children: children}), do: Enum.max(Enum.map(children, &calculate_value/1))
  def calculate_value(%Packet{id: 4, value: value}), do: value
  def calculate_value(%Packet{id: 5, children: [a, b]}), do: b_to_i(calculate_value(a) > calculate_value(b))
  def calculate_value(%Packet{id: 6, children: [a, b]}), do: b_to_i(calculate_value(a) < calculate_value(b))
  def calculate_value(%Packet{id: 7, children: [a, b]}), do: b_to_i(calculate_value(a) == calculate_value(b))
end

defmodule Decoder do
  @type bit::integer()

  def hex_to_bits(input) do
    String.to_integer(input, 16) |> Integer.to_string(2)
    |> String.pad_leading(String.length(input) * 4, "0")
    |> String.graphemes()
  end

  @spec bits_to_int([bit()])::integer()
  def bits_to_int(bits), do: Enum.join(bits, "") |> String.to_integer(2)

  @spec pop_value([bit()], [bit()])::{[bit()], [bit()]}
  def pop_value(bits, acc)
  def pop_value(["1",a1, a2, a3, a4| leftover], acc), do: pop_value(leftover, acc ++ [a1,a2,a3,a4])
  def pop_value(["0",a1, a2, a3, a4| leftover], acc), do: {acc ++ [a1,a2,a3,a4], leftover}

  @spec multi_packet([bit()], integer(), [Packet.t()])::{[Packet.t()],[bit()]}
  def multi_packet(bits, num_packets\\-1, packets\\[])
  def multi_packet([], _num_packets, packets), do: {packets, []}
  def multi_packet(bits, 0, packets), do: {packets, bits}
  def multi_packet(bits, num_packets, packets) do
    {packet, leftover} = decode(bits)
    multi_packet(leftover, num_packets - 1, packets ++ [packet])
  end

  @spec decode_children([bit()])::{[Packet.t()], [bit()]}
  def decode_children(bits)

  def decode_children(["1" | bits ]) do
    {size, bits} = Enum.split(bits, 11)
    size = bits_to_int(size)
    multi_packet(bits, size)
  end

  def decode_children(["0" | bits ]) do
    {size, bits} = Enum.split(bits, 15)
    size = bits_to_int(size)
    {packets, leftover} = Enum.split(bits, size)
    {children, []} = multi_packet(packets)
    {children, leftover}
  end

  @spec decode([bit()])::{Packet.t(), [bit()]}
  def decode(input)

  def decode([v1,v2,v3,"1","0","0"|lit_value]) do
    version =  bits_to_int([v1,v2,v3])
    id = 4
    {value_bits, leftover_bits} = pop_value(lit_value, [])
    value =  bits_to_int(value_bits)
    {%Packet{version: version, id: id, value: value}, leftover_bits}
  end

  def decode([v1,v2,v3,id1,id2,id3|bits]) do
    version = bits_to_int([v1,v2,v3])
    id = bits_to_int([id1,id2,id3])
    {children, leftover} = decode_children(bits)
    {%Packet{version: version, id: id, children: children}, leftover}
  end
end
