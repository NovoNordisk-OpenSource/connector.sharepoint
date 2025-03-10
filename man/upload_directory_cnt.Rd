% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.R
\name{upload_directory_cnt}
\alias{upload_directory_cnt}
\title{Upload folder to sharepoint}
\usage{
upload_directory_cnt(
  connector_object,
  folder,
  name = basename(folder),
  ...,
  recursive = FALSE
)
}
\arguments{
\item{connector_object}{\link{ConnectorSharepoint} object}

\item{folder}{Local folder path}

\item{name}{Folder name to be used when uploaded}

\item{...}{additional paramaeters passed on to \code{upload_folder()} method of \code{\link[Microsoft365R:ms_drive]{Microsoft365R::ms_drive()}} class
or to \code{upload()} method of \code{\link[Microsoft365R:ms_drive_item]{Microsoft365R::ms_drive_item()}} class.}

\item{recursive}{If \code{recursive} is \code{TRUE}, all subfolders will also be transferred recursively. Default: \code{FALSE}}
}
\value{
\link{ConnectorSharepoint} object
}
\description{
Upload folder to the Sharepoint drive or folder
}
