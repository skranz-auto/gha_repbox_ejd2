download_zenodo_zip <- function(record_id=NULL, destdir, destfile = NULL, url=NULL) {

  # url = "https://zenodo.org/record/10693520/files"
  #url = "https://doi.org/10.5281/zenodo.6210284"
  #record_id = str.right.of(url,"zenodo.")

  if is.null(url) {
    file_df = zenodo_list_deposit_files(record_id)
    files = file_df$key
    zip_inds = which(endsWith(files,".zip"))
    if (length(zip_inds)==0) {
      cat("\nWARNING: Zenodo repo contains no zip file.")
      return(NULL)
    } else if (length(zip_inds)>1) {
      cat("\nWARNING: Zenodo repo contains more than one file. Currently we assume that there is just a single zip file.")
      return(NULL)
    }
    zip_ind = min(zip_inds)
    encoded_file_name = URLencode(files[zip_ind])
    url <- paste0("https://zenodo.org/record/", record_id, "/files/", encoded_file_name)
  }
  if (is.null(destfile)) {
    destfile = basename(url)
  }
  download.file(url, file.path(destdir, destfile))
}

zenodo_list_deposit_files = function(zen_id) {
  library(httr)
  library(jsonlite)

  # Make the GET request to Zenodo API
  response <- GET(paste0("https://zenodo.org/api/records/", zen_id))

  # Check if the request was successful
  if (status_code(response) == 200) {
    # Parse the JSON content from the response
    content <- content(response, "text", encoding="UTF-8")
    json_data <- fromJSON(content)

    # Convert the files information to a data frame
    file_df <- as.data.frame(json_data$files)
    return(file_df)
  } else {
    print(paste("Request failed with status", status_code(response)))
    return(NULL)
  }
}
