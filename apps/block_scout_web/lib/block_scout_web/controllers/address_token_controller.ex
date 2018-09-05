defmodule BlockScoutWeb.AddressTokenController do
  use BlockScoutWeb, :controller

  alias Explorer.{Chain, Market}
  alias Explorer.ExchangeRates.Token

  import BlockScoutWeb.AddressController, only: [transaction_count: 1]
  import BlockScoutWeb.Chain, only: [next_page_params: 3, paging_options: 1, split_list_by_page: 1]

  def index(conn, %{"address_id" => address_hash_string} = params) do
    with {:ok, address_hash} <- Chain.string_to_address_hash(address_hash_string),
         {:ok, address} <- Chain.hash_to_address(address_hash) do
      tokens_plus_one = Chain.fetch_tokens_from_address_hash(address_hash, paging_options(params))
      {tokens, next_page} = split_list_by_page(tokens_plus_one)

      tokens = add_number_of_transfers(tokens, address_hash)

      render(
        conn,
        "index.html",
        address: address,
        exchange_rate: Market.get_exchange_rate(Explorer.coin()) || Token.null(),
        transaction_count: transaction_count(address),
        next_page_params: next_page_params(next_page, tokens, params),
        tokens: tokens
      )
    else
      :error ->
        unprocessable_entity(conn)

      {:error, :not_found} ->
        not_found(conn)
    end
  end

  defp add_number_of_transfers(tokens, address_hash) do
    Enum.map(tokens, fn token ->
      Map.put(
        token,
        :number_of_transfers,
        Chain.count_token_transfers_from_address_hash(token.contract_address_hash, address_hash)
      )
    end)
  end
end