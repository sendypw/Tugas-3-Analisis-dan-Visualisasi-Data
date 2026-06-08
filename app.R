library(shiny)
library(readxl)
library(ggplot2)
library(plotly)
library(DT)

# ── Load & bersihkan ──
raw <- read_excel("dataset.xlsx")
df <- data.frame(raw, stringsAsFactors = FALSE)
for (col in names(df)) {
  if (is.character(df[[col]])) {
    num <- suppressWarnings(as.numeric(df[[col]]))
    if (mean(!is.na(num)) > 0.5) df[[col]] <- num
  }
}
all_vars <- names(df)
num_vars <- names(df)[sapply(df, is.numeric)]
cat_vars <- names(df)[!sapply(df, is.numeric)]

# ── Helper aman ──
`%||%` <- function(a, b) if (is.null(a) || is.na(a)) b else a
guard <- function(x) if (is.null(x) || length(x) != 1 || is.na(x)) FALSE else TRUE

# ── UI ──
ui <- fluidPage(
  titlePanel("Visualisasi Data Cuaca Interaktif"),

  sidebarLayout(
    sidebarPanel(
      selectInput("x", "Variabel X", all_vars, "MaxTemp"),
      selectInput("y", "Variabel Y", all_vars, "Rainfall"),

      radioButtons("tipe", "Jenis Plot",
        c("Scatter" = "scatter", "Line" = "line", "Bar" = "bar"),
        "scatter", inline = TRUE),

      conditionalPanel(
        condition = "input.tipe == 'scatter'",
        checkboxInput("warna", "Warnai berdasarkan kategori", TRUE),
        selectInput("var_warna", NULL, cat_vars,
          if ("RainToday" %in% cat_vars) "RainToday" else cat_vars[1]),
        checkboxInput("smooth", "Tampilkan garis smooth", TRUE)
      ),

      conditionalPanel(
        condition = "input.tipe == 'bar'",
        selectInput("agregasi", "Agregasi",
          c("Rata-rata" = "mean", "Total" = "sum", "Jumlah" = "count"), "mean")
      ),

      conditionalPanel(
        condition = "false",
        checkboxInput("tampil_na", NULL, FALSE)
      )
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotlyOutput("plot", height = "500px")),
        tabPanel("Tabel Data",
          checkboxInput("tampil_na", "Tampilkan baris dengan NA", FALSE),
          DTOutput("tabel")),
        tabPanel("Info Dataset",
          h4("Ringkasan"),
          verbatimTextOutput("info"),
          h4("Tipe Data per Variabel"),
          DTOutput("tipe_data"))
      )
    )
  )
)

# ── Server ──
server <- function(input, output, session) {

  output$plot <- renderPlotly({
    if (!guard(input$x) || !guard(input$y) || !guard(input$tipe)) {
      validate("Pilih variabel X dan Y")
      return(NULL)
    }
    x <- input$x; y <- input$y; tipe <- input$tipe
    if (!x %in% names(df) || !y %in% names(df)) {
      validate("Variabel tidak ditemukan")
      return(NULL)
    }
    if (!tipe %in% c("scatter", "line", "bar")) return(NULL)

    dat <- df[, c(x, y), drop = FALSE]
    dat <- dat[complete.cases(dat), , drop = FALSE]
    if (nrow(dat) < 2) {
      validate(paste("Minimal 2 baris data valid. Saat ini:", nrow(dat)))
      return(NULL)
    }
    colnames(dat) <- c("xv", "yv")

    if (identical(tipe, "scatter")) {
      warna_on <- isTRUE(input$warna) &&
        !is.null(input$var_warna) &&
        isTRUE(input$var_warna %in% names(df))

      if (warna_on) {
        cv <- input$var_warna
        dat <- df[, c(x, y, cv), drop = FALSE]
        dat <- dat[complete.cases(dat), , drop = FALSE]
        if (nrow(dat) < 2) return(NULL)
        colnames(dat) <- c("xv", "yv", "wrn")
        p <- ggplot(dat, aes(xv, yv, color = wrn)) +
          geom_point(size = 2, alpha = 0.7) +
          labs(color = cv)
      } else {
        p <- ggplot(dat, aes(xv, yv)) +
          geom_point(color = "#3498db", size = 2, alpha = 0.7)
      }
      if (isTRUE(input$smooth)) {
        p <- p + geom_smooth(method = "loess", se = TRUE,
                             color = "#e74c3c", fill = "#f1948a", alpha = 0.2)
      }

    } else if (identical(tipe, "line")) {
      dat <- dat[order(dat$xv), ]
      dat$urut <- 1:nrow(dat)
      p <- ggplot(dat, aes(urut, yv)) +
        geom_line(color = "#2ecc71", linewidth = 0.8) +
        geom_point(color = "#27ae60", size = 1.5, alpha = 0.6) +
        labs(x = x)

    } else { # bar
      if (is.numeric(dat$xv)) {
        dat$grp <- cut(dat$xv, 10, include.lowest = TRUE)
      } else {
        dat$grp <- factor(dat$xv)
      }
      agg <- input$agregasi %||% "mean"
      if (identical(agg, "count")) {
        bar <- as.data.frame(table(dat$grp))
        names(bar) <- c("grp", "nilai")
        ylab <- "Jumlah"
      } else if (identical(agg, "sum")) {
        bar <- aggregate(yv ~ grp, dat, sum, na.rm = TRUE)
        names(bar)[2] <- "nilai"
        ylab <- paste("Total", y)
      } else {
        bar <- aggregate(yv ~ grp, dat, mean, na.rm = TRUE)
        names(bar)[2] <- "nilai"
        ylab <- paste("Rata-rata", y)
      }
      if (nrow(bar) == 0) return(NULL)
      p <- ggplot(bar, aes(grp, nilai)) +
        geom_col(fill = "#9b59b6", alpha = 0.8) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(y = ylab, x = x)
    }

    p <- p + labs(title = paste(x, "vs", y, "-", tipe)) +
      theme_minimal(13) +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            legend.position = "bottom")

    ggplotly(p) %>%
      config(displaylogo = FALSE,
        modeBarButtonsToRemove = c("lasso2d", "select2d"),
        toImageButtonOptions = list(format = "png",
          filename = paste0("plot_", x, "_vs_", y),
          width = 1100, height = 600))
  })

  # ── Tabel Data ──
  output$tabel <- renderDT({
    tbl <- df
    if (!isTRUE(input$tampil_na)) tbl <- tbl[complete.cases(tbl), , drop = FALSE]
    if (nrow(tbl) == 0) return(datatable(data.frame(Pesan = "Tidak ada data")))
    numerik <- names(tbl)[sapply(tbl, is.numeric)]
    dt <- datatable(tbl, options = list(pageLength = 15, scrollX = TRUE),
                    rownames = FALSE, filter = "top", class = "cell-border stripe hover")
    if (length(numerik) > 0) dt <- dt %>% formatRound(numerik, 2)
    dt
  })

  # ── Info ──
  output$info <- renderPrint({
    cat(sprintf("Baris: %d\nKolom: %d\nNumerik: %d\nKategorik: %d\nNA total: %d",
                nrow(df), ncol(df), length(num_vars), length(cat_vars),
                sum(is.na(df))))
  })

  output$tipe_data <- renderDT({
    info <- data.frame(
      Variabel = names(df),
      Tipe = sapply(df, function(x) class(x)[1]),
      NA_kolom = sapply(df, function(x) sum(is.na(x))),
      Unique = sapply(df, function(x) length(unique(na.omit(x)))),
      row.names = NULL, check.names = FALSE)
    datatable(info, options = list(pageLength = 25, scrollX = TRUE),
              rownames = FALSE, class = "cell-border stripe")
  })
}

shinyApp(ui, server)
