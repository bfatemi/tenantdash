

# DEFINE HELPER FUNS AND SET INIT OPTIONS ---------------------------------

options(devtools.name = "Bobby Fatemi")
options(devtools.desc.license = "file LICENSE")
options(devtools.desc.author =  'person(email = "bfatemi07@gmail.com", role = c("aut", "cre"), given = "Bobby", family = "Fatemi")')

options(devtools.desc = list(
   Description = "[DOCUMENTATION NEEDED] DESCRIPTION.",
   Title = "[DOCUMENTATION NEEDED] TITLE")
)

use_prop_license <- function(path){
   fileName <- "LICENSE"
   fpath <- paste0(path, "/", fileName)
   if(file.exists(fpath)) stop("License file exists already", call. = FALSE)
   txt <- paste0("Proprietary\n\nDo not distribute\nYEAR: ", gsub("(?<=20[0-9][0-9]).+", "", Sys.Date(), perl = TRUE), "\nCOPYRIGHT HOLDER: Bobby Fatemi")
   file.create(fpath)
   writeLines(txt, fpath)
   invisible(TRUE)
}

use_dev_dir <- function(path){
   dirName <- "development"
   dpath <- paste0(path, "/R/", dirName)
   if(dir.exists(dpath)) stop("development directory already exists", call. = FALSE)
   dir.create(dpath, recursive = TRUE)
   devtools::use_build_ignore(dirName, pkg = path)
   invisible(TRUE)
}
use_priv_dir <- function(path){
   dirName <- "private"
   dpath <- paste0(path, "/", dirName)
   if(dir.exists(dpath)) stop("private directory already exists", call. = FALSE)
   dir.create(dpath)
   devtools::use_build_ignore(dirName, pkg = path)

   if(file.exists(".gitignore"))
      cat("private", file = ".gitignore", append = TRUE)
   invisible(TRUE)
}



# BEGIN SCRIPT TO INIT NEW PACKAGE ----------------------------------------


pkg_dir <- "."
devtools::use_package_doc(pkg_dir)
file.remove("DESCRIPTION")
file.remove("NAMESPACE")
devtools::create_description(pkg_dir)
devtools::document(pkg_dir)

use_prop_license(pkg_dir)
use_dev_dir(pkg_dir)
use_priv_dir(pkg_dir)

devtools::use_testthat(pkg_dir)
devtools::use_github(pkg = pkg_dir)

trav_txt <- capture.output(devtools::use_travis(pkg = pkg_dir), type = "message")
trav_link <- trav_txt[length(trav_txt)]

try(devtools::use_readme_md(devtools::as.package(pkg_dir)), silent = TRUE)

rm_path <- paste0(pkg_dir, "/README.md")
rm_txt <- readLines(rm_path)
rm_txt[1] <- paste0(rm_txt[1], " ", trav_link)
writeLines(paste0(rm_txt, collapse = "\n"), rm_path)
