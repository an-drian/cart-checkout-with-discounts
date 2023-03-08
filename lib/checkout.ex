defmodule Checkout do
  @path_to_json "../prices.json"

  @type cart :: %{
          voucher: non_neg_integer(),
          tshirt: non_neg_integer(),
          mug: non_neg_integer()
        }
  @type product_codes :: :voucher | :tshirt | :mug

  @spec new() :: cart()
  def new, do: %{voucher: 0, tshirt: 0, mug: 0}

  @spec scan(cart :: cart(), product_code :: product_codes()) :: cart() | {:error, binary()}
  def scan(cart, product_code) do
    if valid_product_code?(product_code) do
      Map.put(cart, product_code, cart[product_code] + 1)
    else
      {:error, "invalid product code"}
    end
  end

  @spec total(cart :: cart()) :: integer()
  def total(cart) do
    with {:ok, prices} <- get_prices_from_json() do
      price_map =
        Enum.map(prices, fn {key, value} ->
          {key |> String.downcase() |> String.to_atom(), value}
        end)

      Enum.reduce(cart, 0, fn {key, count}, acc ->
        acc + calc_price_for(key, price_map[key], count)
      end)
      |> Float.round(2)
    end
  end

  defp get_prices_from_json(filename \\ @path_to_json)

  defp get_prices_from_json(filename) do
    with {:ok, body} <- File.read(filename), {:ok, json} <- Poison.decode(body), do: {:ok, json}
  end

  defp valid_product_code?(product_code), do: product_code in [:voucher, :tshirt, :mug]

  defp calc_price_for(_, _, 0), do: 0

  # we take the number of odd numbers in the interval from zero to n where n is the number of orders, Then we simply multiply this number by the cost.
  # This will actually be the implementation of the 2-for-1 rule
  defp calc_price_for(:voucher, price, number_of_orders),
    do: ((number_of_orders / 2) |> ceil()) * price

  # here we just check if number of ordered t-shirts greater then 2, we reduce the cost by 1 euro
  defp calc_price_for(:tshirt, price, number_of_orders),
    do:
      if(number_of_orders > 2, do: number_of_orders * (price - 1), else: number_of_orders * price)

  defp calc_price_for(_, price, number_of_orders), do: number_of_orders * price
end
