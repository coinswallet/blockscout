defmodule BlockScoutWeb.AddressTokenView do
  use BlockScoutWeb, :view

  import BlockScoutWeb.AddressView,
    only: [contract?: 1, smart_contract_verified?: 1, smart_contract_with_read_only_functions?: 1]

  def number_of_transfers(token) do
    ngettext("%{count} transfer", "%{count} transfers", token.number_of_transfers)
  end
end
