defmodule Packet do
  # id 4 == literal value
  # id !4 == operator  (one or more sub-packets)
  defstruct version: Nil,
            id: Nil,
            value: 0,
            children: []

  @type t :: %__MODULE__{
    version: integer(),
    id: integer(),
    value: integer(),
    children: [Packet.t()]
    }

    @spec add_version(Packet.t())::integer()
    def add_version(packet) do
       packet.version + Enum.sum(
        Enum.map(packet.children, &add_version/1)
      )
    end

    @spec calculate_value(Packet.t())::integer()
    def calculate_value(packet)

    def calculate_value(%Packet{
      id: 0,
      children: children
    }) do
      Enum.sum(Enum.map(children, &calculate_value/1))
    end

    def calculate_value(%Packet{
      id: 1,
      children: [child]
    }) do
      calculate_value(child)
    end

    def calculate_value(%Packet{
      id: 1,
      children: children
    }) do
      Enum.product(Enum.map(children, &calculate_value/1))
    end

    def calculate_value(%Packet{
      id: 2,
      children: children
    }) do
      Enum.min(Enum.map(children, &calculate_value/1))
    end

    def calculate_value(%Packet{
      id: 3,
      children: children
    }) do
      Enum.max(Enum.map(children, &calculate_value/1))
    end

    def calculate_value(%Packet{
      id: 4,
      value: value
    }) do
      value
    end

    def calculate_value(%Packet{
      id: 5,
      children: [a, b]
    }) do
      if calculate_value(a) > calculate_value(b) do
        1
      else
        0
      end
    end

    def calculate_value(%Packet{
      id: 6,
      children: [a, b]
    }) do
      if calculate_value(a) < calculate_value(b) do
        1
      else
        0
      end
    end

    def calculate_value(%Packet{
      id: 7,
      children: [a, b]
    }) do
      a = calculate_value(a)
      b = calculate_value(b)
      if a == b do
        1
      else
        0
      end
    end
end

defmodule Decoder do
  @type bit::integer()

  #
  # HELPER FUNCTIONS
  #
  def adjust_bits(out)
  def adjust_bits(out) when rem(length(out), 4) == 0 do out end
  def adjust_bits(out) do adjust_bits([0|out]) end

  def hex_to_bits(input) do
    out = input |> String.to_integer(16) |> Integer.to_string(2) |> String.graphemes()
    adjust_bits(out)
  end

  @spec bits_to_int([bit()])::integer()
  def bits_to_int(bits)

  def bits_to_int(bits) do
    bits |> Enum.join("") |> String.to_integer(2)
  end

  def pop_value(bits, acc)

  def pop_value(["1",a1, a2, a3, a4| leftover], acc) do
    acc = acc ++ [a1,a2,a3,a4]
    pop_value(leftover, acc)
  end

  def pop_value(["0",a1, a2, a3, a4| leftover], acc) do
    acc = acc ++ [a1,a2,a3,a4]
    {acc, leftover}
  end

  @spec multi_packet([bit()], integer(), [Packet.t()])::{[Packet.t()],[bit()]}
  def multi_packet(bits, num_packets\\-1, packets\\[])

  def multi_packet([], _num_packets, packets) do
    {packets, []}
  end

  def multi_packet(bits, 0, packets) do
    {packets, bits}
  end

  def multi_packet(bits, num_packets, packets) do
    {packet, leftover} = decode(bits)
    multi_packet(leftover, num_packets - 1, packets ++ [packet])
  end

  #
  # PARSING
  #

  @spec decode_children([bit()])::{[Packet.t()], [bit()]}
  def decode_children(bits)

  def decode_children(["1" | bits ]) do
    {size, bits} = Enum.split(bits, 11)
    size = bits_to_int(size) # Number of packets: don't know why we need it.
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
  #packet with ID == 4
  def decode([v1,v2,v3,"1","0","0"|lit_value]) do
    version =  bits_to_int([v1,v2,v3])
    id = 4
    {value_bits, leftover_bits} = pop_value(lit_value, [])
    value =  bits_to_int(value_bits)
    packet = %Packet{
      version: version,
      id: id,
      value: value
    }
    {packet, leftover_bits}
  end

  def decode([v1,v2,v3,id1,id2,id3|bits]) do
    version = bits_to_int([v1,v2,v3])
    id = bits_to_int([id1,id2,id3])
    {children, leftover} = decode_children(bits)
    packet = %Packet{
      version: version,
      id: id,
      children: children
    }
    {packet, leftover}
  end
end
