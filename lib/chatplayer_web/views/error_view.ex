defmodule ChatplayerWeb.ErrorView do
  use ChatplayerWeb, :view

  def render("500.json-api", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  def render("404.json-api", _assigns) do
    %{errors: %{detail: "Item not found"}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
