config = yaml::yaml.load_file("/root/repbox_config.yml")

if (!is.null(config$comment)) {
  try(cat(paste0("\nComment: ", config$comment,"\n")))
}

repo_type = config$repo_type
options(timeout=60*60)

cat("\nRepotype = ", repo_type,"\n")
if (repo_type == "zip_url" | repo_type == "dv") {
  url = config$url
  cat("\nDownload supplement from ", url,"\n")
  options(timeout=60*60)
  download.file(url, "/root/sup/supplement.zip")
} else if (repo_type == "oi") {
  stop("download for oi not implement")
} else if (repo_type == "ze") {
  repo_id = config$repo_id
  url = config$url
  cat("\nDownload Zenodo supplement ", repo_id,"\n")
  source("~/scripts/download_ze.R")
  options(timeout=60*60)
  download_zenodo_zip(repo_id, "/root/sup", url=url)
}

cat("\nResulting content of download folder: /root/sup\n")
print(list.files("/root/sup/"))
cat("\n")
