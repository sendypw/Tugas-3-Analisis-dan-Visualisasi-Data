# Aplikasi Visualisasi Data Interaktif dengan Shiny

**Dataset:** dataset.xlsx  
**File Program:** app.R

---

## 1. Pendahuluan

Tugas 3 mata kuliah Analisis dan Visualisasi Data meminta pembangunan sebuah aplikasi visualisasi data interaktif menggunakan Shiny dalam bahasa pemrograman R. Aplikasi harus memungkinkan pengguna memilih variabel yang ingin divisualisasikan dan jenis plot yang ingin dilihat, mencakup scatter plot interaktif, line plot interaktif, bar plot interaktif, dan tabel data.

Pembangunan aplikasi ini berlandaskan pada konsep visualisasi data interaktif yang dibahas pada Modul 6 BMP MSIM4310. Visualisasi data interaktif merupakan suatu alat dan cara untuk mengomunikasikan data serta membantu memahami data dengan memanfaatkan sistem indra visual manusia. Dalam konteks ini, Shiny sebagai paket R berperan sebagai media untuk mewujudkan visualisasi yang tidak hanya bersifat statis, melainkan juga memungkinkan pengguna untuk berinteraksi secara langsung dengan data melalui antarmuka berbasis web.

Dataset yang digunakan terdiri dari 366 observasi dan 22 variabel, mencakup suhu, curah hujan, kelembaban, tekanan udara, kecepatan dan arah angin, serta indikator hujan. Keberagaman tipe data dalam dataset ini — baik numerik maupun kategorik — menjadikannya tepat untuk dijadikan objek eksplorasi visualisasi interaktif. Dengan aplikasi ini, pengguna dapat secara bebas memilih pasangan variabel yang ingin dianalisis dan menentukan jenis visualisasi yang paling sesuai untuk mengungkap pola atau hubungan antar variabel tersebut.

---

## 2. Landasan Konseptual

### 2.1 Konsep Visualisasi Data Interaktif

Visualisasi data interaktif berada dalam lingkup statistika deskriptif yang secara umum meliputi penyajian data dan ukuran-ukuran numerik. Visualisasi data merupakan suatu cara untuk mengomunikasikan data yang bersifat kompleks menjadi mudah dimengerti oleh audiensi secara umum. Proses visualisasi data terdiri atas empat tahapan utama: akuisisi (*acquire*), penguraian struktur (*parse*), pemilahan (*filter*), dan penambangan (*mine*).

Akuisisi merupakan proses pengambilan data dari sumber, baik internal maupun eksternal. Parse adalah proses memberikan dan mencermati struktur data yang sesuai. Filter merupakan proses pemilahan data sesuai tujuan, sedangkan mine merupakan proses penerapan metode statistik atau data mining untuk memperoleh pola atau informasi dari data. Dalam aplikasi yang dibangun, keempat tahapan ini diterapkan secara berurutan: akuisisi data dilakukan melalui pembacaan file Excel, parse dilakukan dengan mengidentifikasi dan mengonversi tipe data, filter dilakukan melalui pemilihan variabel oleh pengguna melalui antarmuka Shiny, dan mine diwujudkan dalam bentuk visualisasi grafik serta ringkasan statistik yang ditampilkan.

### 2.2 Peran Shiny dalam Visualisasi Interaktif

Shiny merupakan paket R yang memungkinkan pembuatan aplikasi web interaktif secara langsung dari R tanpa memerlukan pengetahuan HTML, CSS, atau JavaScript secara mendalam. Shiny adalah salah satu teknik pemanfaatan R untuk visualisasi data interaktif, termasuk pembuatan dashboard.

Struktur aplikasi Shiny terdiri atas dua komponen utama: (1) fungsi `ui` yang mendefinisikan antarmuka pengguna, dan (2) fungsi `server` yang berisi logika pemrosesan di sisi server. Mekanisme reaktivitas (*reactivity*) memungkinkan output pada server diperbarui secara otomatis setiap kali nilai input berubah, sehingga pengguna dapat melihat perubahan visualisasi secara langsung tanpa harus memuat ulang halaman.

---

## 3. Struktur Dataset

Dataset `dataset.xlsx` berisi data cuaca harian yang mencakup 366 observasi dengan 22 variabel. Data statistik dapat dibedakan menjadi data kualitatif dan data kuantitatif. Dalam dataset ini, variabel kuantitatif (numerik) meliputi suhu, curah hujan, tekanan udara, kelembaban, kecepatan angin, dan evapotranspirasi, sedangkan variabel kualitatif (kategorik) meliputi arah angin, indikator hujan hari ini, dan prediksi hujan untuk hari berikutnya.

| No | Variabel | Tipe | Keterangan |
|----|----------|------|------------|
| 1 | MinTemp | Numerik | Suhu minimum (°C) |
| 2 | MaxTemp | Numerik | Suhu maksimum (°C) |
| 3 | Rainfall | Numerik | Curah hujan (mm) |
| 4 | Evaporation | Numerik | Evaporasi (mm) |
| 5 | Sunshine | Numerik | Sinar matahari (jam) |
| 6 | WindGustDir | Kategorik | Arah hembusan angin |
| 7 | WindGustSpeed | Numerik | Kecepatan hembusan angin (km/h) |
| 8 | WindDir9am | Kategorik | Arah angin jam 9 pagi |
| 9 | WindDir3pm | Kategorik | Arah angin jam 3 sore |
| 10 | WindSpeed9am | Numerik | Kecepatan angin jam 9 pagi |
| 11 | WindSpeed3pm | Numerik | Kecepatan angin jam 3 sore |
| 12 | Humidity9am | Numerik | Kelembaban jam 9 pagi (%) |
| 13 | Humidity3pm | Numerik | Kelembaban jam 3 sore (%) |
| 14 | Pressure9am | Numerik | Tekanan udara jam 9 pagi (hPa) |
| 15 | Pressure3pm | Numerik | Tekanan udara jam 3 sore (hPa) |
| 16 | Cloud9am | Numerik | Tutupan awan jam 9 pagi |
| 17 | Cloud3pm | Numerik | Tutupan awan jam 3 sore |
| 18 | Temp9am | Numerik | Suhu jam 9 pagi (°C) |
| 19 | Temp3pm | Numerik | Suhu jam 3 sore (°C) |
| 20 | RainToday | Kategorik | Hujan hari ini (Yes/No) |
| 21 | RISK_MM | Numerik | Risiko curah hujan (mm) |
| 22 | RainTomorrow | Kategorik | Prediksi hujan besok (Yes/No) |

---

## 4. Pembahasan Program `app.R`

### 4.1 Arsitektur Aplikasi

Aplikasi dibangun dengan pendekatan Shiny standar yang terdiri atas komponen antarmuka (`ui`) dan logika server (`server`). Seluruh kode ditulis dalam satu file `app.R` untuk kemudahan distribusi dan eksekusi. Pembagian tugas antara ui dan server mengikuti prinsip pemisahan tampilan dan logika yang direkomendasikan dalam pengembangan aplikasi Shiny.

### 4.2 Bagian Persiapan Data

Sebelum memasuki definisi ui dan server, dilakukan pemuatan (*loading*) dan pembersihan data. Dataset dibaca dari file Excel menggunakan fungsi `read_excel()`, kemudian dikonversi ke dalam format *data frame*. Kolom-kolom yang semula bertipe karakter tetapi berisi data numerik (seperti `MinTemp`, `MaxTemp`, `Rainfall`, dan sebagainya) dikonversi secara otomatis ke tipe numerik melalui pendeteksian proporsi nilai numerik dalam setiap kolom. Proses ini mencerminkan tahapan *parse* yang dijelaskan dalam BMP, yaitu memberikan dan mencermati struktur data yang sesuai dan tepat pada data yang akan diolah.

Setelah konversi, variabel-variabel dikelompokkan menjadi dua kategori: `num_vars` untuk variabel numerik dan `cat_vars` untuk variabel kategorik. Pengelompokan ini digunakan untuk menyesuaikan jenis kontrol input yang ditampilkan kepada pengguna — misalnya, variabel kategorik digunakan sebagai opsi pewarnaan pada scatter plot, sedangkan variabel numerik menjadi subjek dari agregasi pada bar plot.

### 4.3 Antarmuka Pengguna (UI)

Antarmuka pengguna dibangun menggunakan `fluidPage` dengan tata letak `sidebarLayout`. Di panel samping (*sidebar*), pengguna dapat memilih:

1. **Variabel X dan Variabel Y** melalui `selectInput`, yang mencakup seluruh 22 variabel dalam dataset.
2. **Jenis plot** melalui `radioButtons`, dengan tiga pilihan: Scatter, Line, dan Bar.
3. **Opsi spesifik per jenis plot** yang hanya tampil ketika jenis plot terkait dipilih, menggunakan mekanisme `conditionalPanel`.

Pada panel utama (*main panel*), terdapat tiga tab yang ditata menggunakan `tabsetPanel`:

- **Tab Plot** — menampilkan visualisasi grafik interaktif melalui `plotlyOutput`.
- **Tab Tabel Data** — menampilkan data dalam bentuk tabel interaktif melalui `DTOutput`, dilengkapi dengan opsi untuk menampilkan atau menyembunyikan baris yang mengandung nilai NA.
- **Tab Info Dataset** — menampilkan ringkasan dataset berupa jumlah baris, kolom, tipe variabel, dan jumlah nilai NA, serta tabel tipe data per variabel.

Pemilihan tata letak ini didasarkan pada prinsip penyajian data yang efektif, sebagaimana dijelaskan dalam BMP Modul 1, di mana penyajian data harus dilakukan dengan baik, menarik, dan tepat agar mudah dipahami dan memberikan informasi yang bermakna. Dengan memisahkan plot, tabel, dan informasi struktural ke dalam tab yang berbeda, pengguna dapat fokus pada satu aspek eksplorasi pada satu waktu.

### 4.4 Logika Server

Fungsi server terdiri atas tiga keluaran (*output*) utama dan dilengkapi dengan mekanisme *guard* untuk menangani kondisi di mana input belum tersedia atau tidak valid, terutama pada sesi awal saat aplikasi baru dimuat.

#### a. Guard Input

Dua fungsi pembantu didefinisikan untuk keamanan penanganan input:

```r
`%||%` <- function(a, b) if (is.null(a) || is.na(a)) b else a
guard <- function(x) if (is.null(x) || length(x) != 1 || is.na(x)) FALSE else TRUE
```

Fungsi `guard` memeriksa apakah suatu nilai input valid (tidak NULL, tidak NA, dan memiliki panjang 1). Operator `%||%` menyediakan nilai fallback jika input tidak tersedia. Pendekatan ini dipilih untuk menghindari kesalahan *coercion* yang dapat terjadi pada beberapa versi R ketika fungsi `req()` menerima nilai NA.

#### b. Render Plot (`renderPlotly`)

Fungsi `renderPlotly` menangani pembuatan plot untuk scatter, line, dan bar. Logika pemilihan jenis plot menggunakan `identical()` sebagai pengganti operator `==` untuk menghindari kesalahan ketika nilai input tidak sesuai dengan tipe yang diharapkan. Setiap jenis plot memiliki penanganan data yang berbeda:

- **Scatter plot**: Data difilter untuk mengambil baris yang lengkap (*complete cases*) pada kolom X, Y, dan (jika digunakan) variabel warna. Pewarnaan berdasarkan kategori menggunakan skema warna default ggplot2. Apabila opsi *smooth* diaktifkan, ditambahkan garis regresi non-parametrik LOESS dengan interval kepercayaan.

- **Line plot**: Data diurutkan berdasarkan nilai variabel X, kemudian divisualisasikan sebagai garis berkesinambungan. Pendekatan ini sejalan dengan fungsi grafik garis yang dijelaskan dalam BMP Modul 1, yaitu untuk melihat pertumbuhan atau perkembangan suatu kejadian.

- **Bar plot**: Variabel X yang bersifat numerik akan dikelompokkan ke dalam 10 interval (*binning*), sedangkan variabel kategorik langsung dijadikan sebagai sumbu kategori. Pengguna dapat memilih fungsi agregasi: rata-rata, total, atau jumlah observasi. Hal ini memungkinkan eksplorasi data dari berbagai perspektif agregatif.

Setelah plot dibuat dengan `ggplot2`, objek dikonversi ke format `plotly` menggunakan fungsi `ggplotly()`, yang memberikan interaktivitas seperti *hover tooltip*, *zoom*, *pan*, dan tombol unduh gambar.

#### c. Render Tabel (`renderDT`)

Tabel data menggunakan paket `DT`, yang merupakan antarmuka R untuk pustaka JavaScript DataTables. Tabel menyediakan fungsionalitas pencarian global, filter per kolom, pengurutan, dan navigasi halaman. Opsi `formatRound` digunakan untuk membulatkan angka numerik hingga dua desimal, sehingga tampilan tabel lebih rapi dan mudah dibaca.

#### d. Informasi Dataset

Ringkasan dataset ditampilkan menggunakan `renderPrint` dengan format teks, sedangkan tabel tipe data per variabel ditampilkan menggunakan `renderDT` untuk konsistensi tampilan.

### 4.5 Kode Program Lengkap

```r
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

    } else {
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
```

### 4.6 Cara Menjalankan Aplikasi

Aplikasi memerlukan beberapa paket R yang harus diinstal terlebih dahulu:

```r
install.packages(c("shiny", "readxl", "ggplot2", "plotly", "DT"))
```

Setelah paket terinstal, aplikasi dapat dijalankan dengan:

```r
shiny::runApp("app.R")
```

Aplikasi akan terbuka di peramban (*browser*) default pada alamat `http://127.0.0.1:PORT`.

---

## 5. Analisis dan Interpretasi Fitur

### 5.1 Scatter Plot Interaktif

Scatter plot merupakan metode presentasi secara grafis untuk menggambarkan hubungan antara dua variabel kuantitatif. Dalam aplikasi, scatter plot menampilkan titik-titik data pada bidang dua dimensi di mana variabel X ditempatkan pada sumbu horizontal dan variabel Y pada sumbu vertikal. Pola yang ditunjukkan oleh titik-titik tersebut menggambarkan hubungan yang terjadi antar variabel.

Fitur pewarnaan berdasarkan kategori menambahkan dimensi ketiga ke dalam visualisasi, sehingga pengguna dapat mengamati apakah pola hubungan antara dua variabel numerik berbeda antar kelompok kategori. Misalnya, ketika scatter plot `MaxTemp` terhadap `Humidity3pm` diwarnai berdasarkan `RainToday`, dapat diamati secara visual bahwa observasi dengan kategori hujan (Yes) cenderung terkonsentrasi pada area dengan kelembaban tinggi dan suhu yang lebih rendah.

Garis smooth LOESS yang dapat diaktifkan memberikan gambaran tentang tren non-linear dalam data. Hal ini membantu pengguna mengidentifikasi pola yang mungkin tidak terlihat apabila hanya mengamati titik-titik data secara individual.

### 5.2 Line Plot Interaktif

Grafik garis (*line chart*), berfungsi untuk melihat pertumbuhan atau perkembangan suatu kejadian. Dalam konteks aplikasi, line plot menyajikan data dalam urutan tertentu berdasarkan nilai variabel X. Setiap titik data dihubungkan oleh garis lurus, sehingga fluktuasi nilai antar observasi berurutan dapat diamati dengan jelas.

Fitur interaktif pada line plot — terutama *hover tooltip* yang menampilkan urutan, nilai X, dan nilai Y — memungkinkan pengguna untuk mengidentifikasi observasi-observasi tertentu yang menyimpang dari pola umum.

### 5.3 Bar Plot Interaktif

Grafik batang (*bar graph*), berfungsi untuk melihat distribusi atau perbandingan nilai, frekuensi, atau persentase di setiap kelas (kategori). Dalam aplikasi, ketika variabel X bersifat numerik, data dikelompokkan ke dalam interval-interval melalui proses *binning* dengan 10 interval yang lebarnya sama. Ketika variabel X bersifat kategorik, setiap kategori langsung menjadi kelompok.

Fungsi agregasi yang dapat dipilih — rata-rata, total, atau jumlah observasi — memberikan fleksibilitas kepada pengguna untuk mengeksplorasi data dari perspektif yang berbeda. Pilihan rata-rata berguna untuk melihat nilai tengah per kelompok, total untuk melihat akumulasi, dan jumlah untuk melihat distribusi frekuensi.

### 5.4 Tabel Data Interaktif

Tabel data yang ditampilkan menggunakan pustaka DT merupakan bentuk penyajian data dalam baris dan kolom. Tabel menyajikan data ke dalam bentuk baris atau kolom sedemikian rupa sehingga memberikan informasi lebih kepada peneliti. Dengan tambahan fitur interaktif seperti filter per kolom, pencarian global, dan pengurutan, tabel menjadi alat eksplorasi data yang lebih kuat dibandingkan tabel statis biasa.

### 5.5 Tab Informasi Dataset

Tab Info Dataset menyediakan dua jenis informasi: ringkasan dataset dan tabel tipe data per variabel. Ringkasan dataset mencakup jumlah baris, jumlah kolom, jumlah variabel numerik dan kategorik, serta jumlah total nilai NA. Informasi ini penting sebagai langkah awal dalam eksplorasi data — pengguna dapat dengan cepat mengetahui ukuran dan karakteristik umum dataset sebelum melakukan visualisasi lebih lanjut. Tabel tipe data per variabel melengkapi informasi ini dengan detail tentang tipe data setiap kolom dan jumlah nilai unik, yang membantu pengguna memahami struktur data secara lebih mendalam sebelum memilih variabel yang akan divisualisasikan.

### 5.6 Integrasi Konsep dengan Implementasi

Proses visualisasi data interaktif dalam aplikasi ini yaitu akuisisi, *parse*, filter, dan *mine*. Akuisisi dilakukan saat dataset dibaca dari file Excel menggunakan `read_excel()`. *Parse* dilakukan saat struktur data dianalisis — kolom karakter yang berisi angka dikonversi ke numerik, dan variabel diklasifikasikan ke dalam kelompok numerik dan kategorik. Filter terjadi ketika pengguna memilih variabel X, Y, dan jenis plot yang diinginkan — hanya subset data yang relevan yang diproses untuk visualisasi. *Mine* diwujudkan dalam bentuk grafik interaktif, tabel, dan ringkasan statistik yang memungkinkan pengguna menemukan pola atau informasi dari data.

Pendekatan interaktif ini sejalan dengan tujuan visualisasi data sebagaimana diuraikan dalam BMP, yaitu membantu pengguna memahami data dengan memanfaatkan sistem indra visual manusia melalui tampilan grafik yang efektif dan menarik. Dengan memberikan kendali penuh kepada pengguna untuk memilih variabel dan jenis visualisasi, aplikasi ini mengubah proses eksplorasi data dari aktivitas satu arah menjadi dialog dua arah antara pengguna dan data.

---

## 6. Kesimpulan

Aplikasi visualisasi data interaktif yang dibangun menggunakan Shiny berhasil memenuhi kebutuhan tugas, yaitu menyediakan antarmuka yang memungkinkan pengguna memilih variabel dan jenis plot secara bebas. Aplikasi mencakup tiga jenis visualisasi: scatter plot interaktif, line plot interaktif, dan bar plot interaktif, serta dilengkapi dengan tabel data interaktif. Seluruh jenis visualisasi dilengkapi dengan fitur interaktif seperti *hover tooltip*, *zoom*, dan unduh gambar.

Pembangunan aplikasi didasarkan pada konsep visualisasi data interaktif yang diuraikan dalam BMP MSIM4310, khususnya Modul 6 yang membahas visualisasi data interaktif serta Modul 1 yang membahas prinsip dasar penyajian data dan bentuk-bentuk penyajian data. Melalui integrasi antara teori penyajian data dan implementasi teknis menggunakan R dan Shiny, aplikasi ini diharapkan dapat menjadi alat eksplorasi data yang bermanfaat untuk menganalisis pola dan hubungan antar variabel dalam dataset.
