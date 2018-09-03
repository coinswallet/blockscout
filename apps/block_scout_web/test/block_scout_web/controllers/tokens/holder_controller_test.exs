defmodule BlockScoutWeb.Tokens.HolderControllerTest do
  use BlockScoutWeb.ConnCase

  describe "GET index/3" do
    test "with invalid address hash", %{conn: conn} do
      conn = get(conn, token_holder_path(BlockScoutWeb.Endpoint, :index, "invalid_address"))

      assert html_response(conn, 404)
    end

    test "with a token that doesn't exist", %{conn: conn} do
      address = build(:address)
      conn = get(conn, token_holder_path(BlockScoutWeb.Endpoint, :index, address.hash))

      assert html_response(conn, 404)
    end

    test "successfully renders the page", %{conn: conn} do
      token = insert(:token)

      insert_list(
        2,
        :token_balance,
        token_contract_address_hash: token.contract_address_hash
      )

      conn =
        get(
          conn,
          token_holder_path(BlockScoutWeb.Endpoint, :index, token.contract_address_hash)
        )

      assert html_response(conn, 200)
    end
  end
end
