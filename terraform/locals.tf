locals {
  common_tags  = var.common_tags
  project_name = var.project_name

  endpoints = [
    { name = "list-games", method = "GET", description = "Retrieves a list of games" },
    { name = "create-game", method = "POST", description = "Creates a new game" },
    { name = "update-game", method = "PUT", description = "Updates an existing game" },
    { name = "external-call", method = "GET", description = "Calls an external API on the internet" }
  ]
}