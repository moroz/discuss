defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    changeset = Topic.changeset(%Topic{}, topic_params)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created.")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Topic could not be created.")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic_params}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic, topic_params)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated.")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Topic could not be saved.")
        |> render("edit.html", changeset: changeset, topic: topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!()

    conn
    |> put_flash(:info, "Topic deleted.")
    |> redirect(to: topic_path(conn, :index))
  end
end
