defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  alias Discuss.User
  plug(Ueberauth)

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: "github"
    }

    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  def callback(conn, _params), do: handle_error(conn)

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))

      {:error, _reason} ->
        handle_error(conn)
    end
  end

  def handle_error(conn) do
    conn
    |> put_flash(:error, "An error occurred while authenticating your account.")
    |> redirect(to: topic_path(conn, :index))
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end
