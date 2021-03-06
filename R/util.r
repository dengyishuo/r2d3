vector_only <- function(x) {
  x <- unclass(x)
  
  # Recursively apply to lists
  list <- vapply(x, is.list, logical(1))
  x[list] <- lapply(x[list], vector_only)
  
  # Remove any non vector (e.g. function) components
  atomic <- vapply(x, is.vector, logical(1))
  x[atomic]
}
compact_rec <- function(x) {
  list <- vapply(x, is.list, logical(1))
  x[list] <- lapply(x[list], compact_rec)

  Filter(function(x) length(x) > 0, x)
}
name_matches <- function(x, pattern) {
  matches <- grepl(pattern, names(x))
  new_names <- gsub(pattern, "", names(x)[matches])
  setNames(x[matches], new_names)
}



inst_path <- function() {
  envname <- environmentName(parent.env(environment()))
  
  if (envname == "r2d3") {
    # Probably in package
    system.file(package = "r2d3")
  } else {
    # Probably in development
    srcref <- attr(inst_path, "srcref")
    path <- dirname(dirname(attr(srcref, "srcfile")$filename))
    file.path(path, "inst")
  }
}