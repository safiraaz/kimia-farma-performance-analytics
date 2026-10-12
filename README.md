# Kimia Farma Performance Analytics 2020-2023

Final Task Project-Based Internship **Big Data Analytics**, Kimia Farma x Rakamin Academy.

Analisis kinerja bisnis Kimia Farma tahun 2020 sampai 2023 menggunakan **Google BigQuery** (pengolahan data dengan SQL) dan **Looker Studio** (dashboard).

## Tautan

| | |
|---|---|
| Dashboard | [Buka dashboard](https://datastudio.google.com/reporting/df6418e9-e58c-4273-b7a5-f1f2cee12282) |
| Video presentasi | [Buka Youtube](https://youtu.be/uMI76SGqR9U) |

## Ringkasan

Bisnisnya **stabil, terpusat di Jawa Barat, dan pertumbuhannya datar**.

| Metrik | Nilai |
|---|---|
| Total transaksi | 672.458 |
| Nett sales | Rp321,2 miliar |
| Nett profit | Rp91,2 miliar |
| Margin nett profit | 28,4% |
| Rata-rata rating cabang | 4,45 |
| Rata-rata rating transaksi | 4,00 |
| Cakupan | 1.725 cabang di 31 provinsi |

## Dataset

Empat tabel dari program Rakamin Academy, diimpor ke BigQuery (project `rakamin-kf-analytics`, dataset `kimia_farma`). File data tidak disertakan di repository ini.

| Tabel | Isi |
|---|---|
| `kf_final_transaction` | Data transaksi: tanggal, cabang, produk, harga, diskon, rating |
| `kf_kantor_cabang` | Data cabang: nama, kota, provinsi, kategori, rating |
| `kf_product` | Data produk obat |
| `kf_inventory` | Data stok obat per cabang |

## Alur kerja

1. **Import dataset.** Empat file CSV diimpor ke BigQuery dengan schema auto detect. Format diskon dicek terlebih dahulu: berbentuk desimal (0,1 = 10%), sehingga rumus nett sales memakai `(1 - diskon)`.
2. **Tabel analisa.** Tabel transaksi digabung dengan tabel cabang (`branch_id`) dan tabel produk (`product_id`) memakai `LEFT JOIN`, sehingga semua transaksi tetap ada. Hasilnya tabel `kf_analisa` dengan 16 kolom dan 672.458 baris.
3. **Validasi.** Jumlah cabang kosong 0 dan jumlah produk kosong 0.
4. **Dashboard.** Visualisasi di Looker Studio yang terhubung langsung ke `kf_analisa`.
5. **Analisis tambahan.** Query eksplorasi untuk mencari penyebab di balik angka.

## Tabel analisa `kf_analisa`

Kolom: `transaction_id`, `date`, `branch_id`, `branch_name`, `kota`, `provinsi`, `rating_cabang`, `customer_name`, `product_id`, `product_name`, `actual_price`, `discount_percentage`, `persentase_gross_laba`, `nett_sales`, `nett_profit`, `rating_transaksi`.

**Persentase laba berdasarkan harga:**

| Harga transaksi | Persentase laba |
|---|---|
| Sampai Rp50.000 | 10% |
| Di atas Rp50.000 sampai Rp100.000 | 15% |
| Di atas Rp100.000 sampai Rp300.000 | 20% |
| Di atas Rp300.000 sampai Rp500.000 | 25% |
| Di atas Rp500.000 | 30% |

**Rumus:**
- `nett_sales = actual_price * (1 - discount_percentage)`
- `nett_profit = nett_sales * persentase_gross_laba`

## Dashboard

**Halaman 1: Ringkasan kinerja.** Lima scorecard, filter tanggal dan provinsi, pendapatan per tahun, peta profit per provinsi, Top 10 provinsi (transaksi dan nett sales), Top 5 cabang (rating cabang tertinggi, rating transaksi terendah), dan snapshot data transaksi.

**Halaman 2: Analisis tambahan.** Kontribusi provinsi, jumlah cabang per provinsi, tren nett sales bulanan, Top 5 produk, serta margin, jumlah cabang, dan rata-rata diskon.

## Temuan utama

1. **Nett sales stabil.** Sekitar Rp80 miliar per tahun (80,4; 80,0; 80,6; 80,1), tanpa pertumbuhan dan tanpa pola musiman. Februari lebih rendah hanya karena harinya lebih sedikit.
2. **Jawa Barat dominan karena cabangnya banyak.** Menyumbang 29,5% nett sales dan memiliki 510 dari 1.725 cabang (29,6%). Penjualan per cabang seragam di semua provinsi, sekitar Rp183 sampai 190 juta.
3. **Margin seragam.** 28,3 sampai 28,5% di semua provinsi, sehingga profit mengikuti volume penjualan.
4. **Tidak ada produk atau tipe cabang yang menonjol.** Sepuluh produk teratas masing-masing menyumbang sekitar 1,2 sampai 1,3% penjualan, dan tiga tipe cabang sama kuatnya.
5. **Diskon konstan 7,5% per tahun**, sekitar Rp6,5 miliar per tahun, tanpa pertumbuhan pendapatan yang terlihat.
6. **Rating.** Lima cabang berating 5,0 memiliki rating transaksi 3,91 sampai 3,96. Stok normal (rata-rata 49 dibanding 50) dan tiap cabang hanya punya sekitar 390 transaksi, sehingga selisihnya kemungkinan besar variasi acak.

## Rekomendasi

1. Tambah titik layanan di provinsi padat yang cabangnya sedikit (DKI Jakarta 21, Banten 20, DI Yogyakarta 22 cabang), dengan studi kelayakan terlebih dahulu.
2. Naikkan penjualan per cabang yang stagnan di sekitar Rp186 juta.
3. Uji diskon bertarget dengan A/B test sebagai pengganti diskon rata 7,5%.
4. Pelajari provinsi yang tumbuh (Sulawesi Tengah +7,9%) dan yang turun (Maluku Utara -6,1%).
5. Pantau rating transaksi tiap cabang lintas periode sebelum menyimpulkan ada masalah.

## Keterbatasan

- Data tidak memuat biaya operasional, jumlah penduduk, dan pesaing, sehingga potensi pasar tidak bisa disimpulkan.
- Profit dihitung dari rumus persentase laba pada brief, bukan laba aktual.
- Hubungan sebab-akibat belum diuji.

## Tentang saya

**Safira Aulia Az Zahra**, mahasiswa Informatika, Fakultas Teknologi Informasi dan Sains Data, Universitas Sebelas Maret.

- LinkedIn: [linkedin.com/in/safiraauliaazzahra]
- Email: [safiraulia272006@gmail.com]

*Project ini dibuat sebagai bagian dari Virtual Internship Big Data Analytics, Kimia Farma x Rakamin Academy.*
