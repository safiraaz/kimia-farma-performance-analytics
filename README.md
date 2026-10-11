# kimia-farma-performance-analytics

# Kimia Farma Performance Analytics 2020-2023

Final Task Project-Based Internship Big Data Analytics - Kimia Farma x Rakamin Academy

## Tujuan
Mengevaluasi kinerja bisnis Kimia Farma tahun 2020-2023 melalui analisis data transaksi, cabang, dan produk.

## Tools
- Google BigQuery (pengolahan data dengan SQL)
- Google Looker Studio (dashboard)

## Dataset
- kf_final_transaction: data transaksi
- kf_kantor_cabang: data kantor cabang
- kf_product: data produk obat
- kf_inventory: data stok obat

## Tahapan
1. Import 4 dataset ke BigQuery (dataset: kimia_farma)
2. Membuat tabel analisa `kf_analisa` dengan menggabungkan (LEFT JOIN) tabel transaksi, kantor cabang, dan produk
3. Menghitung kolom baru:
   - persentase_gross_laba berdasarkan rentang harga obat
   - nett_sales = harga setelah diskon
   - nett_profit = nett_sales x persentase_gross_laba
4. Membuat dashboard di Looker Studio

## Hasil
Tabel analisa berisi 672.458 transaksi.

Link Dashboard: (menyusul)
