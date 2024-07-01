library(AzureGraph)
library(Microsoft365R)

# authenticate with AAD
# - on first login, call create_graph_login()
# - on subsequent logins, call get_graph_login()
# gr <- create_graph_login()
#
# initial_token = rstudioapi::getDelegatedAzureToken("https://graph.microsoft.com/")$access_token
#
# client_id = ***
# client_secret = ***
# tenant_id = ***
# tenant <- "novonordisk.onmicrosoft.com"
#
# NEW_SCOPES = "Files.ReadWrite.All Sites.ReadWrite.All"
#
# url = paste0("https://login.microsoftonline.com/", tenant, "/oauth2/v2.0/token")
# payload = list(
#   "grant_type"= "urn:ietf:params:oauth:grant-type:jwt-bearer",
#   "requested_token_use"= "on_behalf_of",
#   "client_id"= client_id,
#   "client_secret"= client_secret,
#   "assertion"= AzureAuth::extract_jwt(initial_token),
#   "scope"= NEW_SCOPES
# )
# headers = list(
#   "Content-Type"= "application/x-www-form-urlencoded"
# )
#
#
# response <- httr::POST(url, body=payload, headers=headers) %>% httr::content()

# tok <- readr::read_rds("~/token_connect.rds")

# tok$credentials
#
# AzureAuth::is_azure_v2_token(tok)
#
# hash <- AzureAuth:::token_hash_internal(tok)
# file.create(paste0("~/.local/share/azureR/", hash))
# readr::write_rds(tok, paste0("~/.local/share/AzureR/", hash))
#
# tok$refresh()
#
# get_tok <- function(){
#   tok <- readr::read_rds("~/token_connect.rds")
#   AzureAuth::is_azure_v2_token(tok)
#   return(tok)
# }
#
#
# do_login <- function (tenant, app, scopes, token = NULL, ...) {
#   if (!is.null(token)) {
#     if (!AzureAuth::is_azure_token(token))
#       stop("Invalid token object supplied")
#     return(ms_graph$new(token = token))
#   }
#   token <- try(get_tok(), silent = TRUE)
#
#   if (!inherits(token, "try-error")) {
#     return(AzureGraph::ms_graph$new(token = token))
#   }
#
#   login <- try(AzureGraph::get_graph_login(tenant, app = app, scopes = scopes,
#                                refresh = FALSE), silent = TRUE)
#   if (inherits(login, "try-error"))
#     login <- AzureGraph::create_graph_login(tenant, app = app, scopes = scopes,
#                                 ...)
#   login
# }
#
# rlang::env_unlock(env = asNamespace('Microsoft365R'))
# rlang::env_binding_unlock(env = asNamespace('Microsoft365R'))
# assign('do_login', do_login, envir = asNamespace('Microsoft365R'))
# rlang::env_binding_lock(env = asNamespace('Microsoft365R'))
# rlang::env_lock(asNamespace('Microsoft365R'))


tok <- readr::read_rds("~/token_connect.rds")

my_share <- Microsoft365R::get_sharepoint_site(site_url = "https://novonordisk.sharepoint.com/sites/Amace-Document-Storage/", token = tok)

doc <- my_share$get_drive()

doc$list_items()
file <- doc$get_item("test.txt")

class(file)

file$download(overwrite = TRUE, dest = "test.txt")

write.csv(iris, "dev/iris.csv")

my_share$get_drive()$upload_file("dev/iris.csv", "Test/iris.csv")

test_folder <- doc$get_item("Test")

do.call(test_folder$list_files, list(info = "name"))

my_share$get_lists()


test <- Connector_sharepoint$new(
  site_url = "https://novonordisk.sharepoint.com/sites/Amace-Document-Storage/",
  token = tok)

something <- test

something$list

item <- something$get_item("Test")

test$read("Test")
test$write(iris, "Test/iris.csv")
test$write("iris.csv", "Test/iris.csv")



