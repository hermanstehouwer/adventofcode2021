ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def ex1() do

  end

  test "test_decode" do
    {source, target} = {"38006F45291200", "00111000000000000110111101000101001010010001001000000000"}
    a = Decoder.hex_to_bits(source) |> Enum.join("")
    assert a == target
  end

  test "example1__type 4" do
    source = "D2FE28"
    bits = Decoder.hex_to_bits(source)
    {packet, _leftover} = Decoder.decode(bits)
    assert packet.value == 2021
  end

  test "example3__type other" do
    source = "EE00D40C823060"
    bits = Decoder.hex_to_bits(source)
    {packet, _leftover} = Decoder.decode(bits)
    assert length(packet.children) == 3
  end

  def test_add({source, expected}) do
    bits = Decoder.hex_to_bits(source)
    {packet, _leftover} = Decoder.decode(bits)
    assert Packet.add_version(packet) == expected
  end
  test "example_additions" do
    [
      {"8A004A801A8002F478", 16},
      {"620080001611562C8802118E34", 12},
      {"C0015000016115A2E0802F182340", 23},
      {"A0016C880162017C3686B18A3D4780", 31}
    ]
    |> Enum.map(&test_add/1)
  end

  def test_calc({source, expected}) do
    bits = Decoder.hex_to_bits(source)
    {packet, _leftover} = Decoder.decode(bits)
    assert Packet.calculate_value(packet) == expected
  end

  test "example_calculations" do
    [
      {"C200B40A82", 3},
      {"04005AC33890", 54},
      {"880086C3E88112", 7},
      {"CE00C43D881120", 9},
      {"D8005AC2A8F0", 1},
      {"F600BC2D8F", 0},
      {"9C005AC2F8F0", 0},
      {"9C0141080250320F1802104A08", 1}
    ]
    |> Enum.map(&test_calc/1)
  end
end
