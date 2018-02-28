defmodule Discuss.User do
  use Discuss.Web, :model

  @required_params [:email, :provider, :token]

  schema "users" do
    field(:email, :string)
    field(:provider, :string)
    field(:token, :string)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
