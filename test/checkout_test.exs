defmodule CheckoutTest do
  use ExUnit.Case
  doctest Checkout

  test "greets the world" do
    assert 32.5 ==
             Checkout.new()
             |> Checkout.scan(:voucher)
             |> Checkout.scan(:tshirt)
             |> Checkout.scan(:mug)
             |> Checkout.total()

    assert 25.0 ==
             Checkout.new()
             |> Checkout.scan(:voucher)
             |> Checkout.scan(:tshirt)
             |> Checkout.scan(:voucher)
             |> Checkout.total()

    assert 81.0 ==
             Checkout.new()
             |> Checkout.scan(:tshirt)
             |> Checkout.scan(:tshirt)
             |> Checkout.scan(:tshirt)
             |> Checkout.scan(:voucher)
             |> Checkout.scan(:tshirt)
             |> Checkout.total()

    assert 74.5 ==
             Checkout.new()
             |> Checkout.scan(:voucher)
             |> Checkout.scan(:tshirt)
             |> Checkout.scan(:voucher)
             |> Checkout.scan(:voucher)
             |> Checkout.scan(:mug)
             |> Checkout.scan(:tshirt)
             |> Checkout.scan(:tshirt)
             |> Checkout.total()
  end
end
