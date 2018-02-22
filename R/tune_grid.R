tune_grid <- function() {
  model_exist <- function(c7, method) {
    for (i in 1:length(c7)) {
      for (j in 1:length(c7_data[[i]])) {
        if (method == c7_data[[i]][[j]]$method) {
          return(TRUE)
        }
      }
    }
    return(FALSE)
  }

  get_params <- function(c7, method) {
    for (i in 1:length(c7)) {
      for (j in 1:length(c7_data[[i]])) {
        if (method == c7_data[[i]][[j]]$method) {
          return(c7_data[[i]][[j]]$tuning_parameters)
        }
      }
    }
    return(NULL)
  }

  create_tune_grid <- function(params, method) {
    if (is.na(params[1])) { return("# No tuning parameters for this model") }

    pr <- paste0(params, " = NA", collapse = ",\n                        ")
    tGrid <- paste0("# Tuning parameters for method '",method,"'\ntuneGrid <- expand.grid(", pr, ")\n")
    return(tGrid)
  }

  get_doc <- rstudioapi::getActiveDocumentContext()
  method <- get_doc$selection[[1]]$text

  if (model_exist(c7_data, method)) {
    params <- get_params(c7_data, method)
    tGrid <- create_tune_grid(params, method)

    start <- get_doc$selection[[1]]$range$start[1]
    if (start - 2 == 0) {
      ind <- 0
    } else {
      ind <- 1:(start-2)
    }

    cont <- get_doc$contents
    cont_new <- c(cont[ind], tGrid, cont[(start-1):(length(cont))])
    cont_txt <- paste(cont_new, collapse = "\n")

    rstudioapi::insertText(rstudioapi::document_range(c(1,1), end = c(length(cont)+1,1)), text = " ", id = get_doc$id)
    rstudioapi::insertText(rstudioapi::document_range(c(1,1), c(1,1)), text = cont_txt, id = get_doc$id)
    rstudioapi::setCursorPosition(rstudioapi::document_range(c(start,1), c(start,1)), id = get_doc$id)
  }
}
