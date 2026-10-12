-- =====================================================================
-- Semua query membaca tabel kf_analisa, jadi jalankan dulu kf_analisa.sql
-- Jalankan satu query per satu kali, lalu lihat hasilnya
-- =====================================================================


-- 1. Top 5 cabang: rating cabang tertinggi, rating transaksi terendah
-- Cabang dengan rating cabang sama diurutkan lagi berdasarkan rating transaksi
SELECT
  branch_id,
  branch_name,
  kota,
  provinsi,
  AVG(rating_cabang) AS rating_cabang,
  AVG(rating_transaksi) AS rata_rata_rating_transaksi
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`
GROUP BY branch_id, branch_name, kota, provinsi
ORDER BY rating_cabang DESC, rata_rata_rating_transaksi ASC
LIMIT 5;


-- 2. Margin profit per provinsi
-- Margin = total nett profit dibagi total nett sales
SELECT
  provinsi,
  SUM(nett_sales) AS total_nett_sales,
  SUM(nett_profit) AS total_nett_profit,
  SAFE_DIVIDE(SUM(nett_profit), SUM(nett_sales)) AS profit_margin
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`
GROUP BY provinsi
ORDER BY profit_margin DESC;


-- 3. Kontribusi tiap provinsi terhadap total nett sales
SELECT
  provinsi,
  SUM(nett_sales) AS total_nett_sales,
  SAFE_DIVIDE(SUM(nett_sales), SUM(SUM(nett_sales)) OVER ()) AS kontribusi
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`
GROUP BY provinsi
ORDER BY kontribusi DESC;


-- 4. Top 10 produk berdasarkan nett profit
SELECT
  product_id,
  product_name,
  COUNT(transaction_id) AS jumlah_transaksi,
  SUM(nett_sales) AS total_nett_sales,
  SUM(nett_profit) AS total_nett_profit
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`
GROUP BY product_id, product_name
ORDER BY total_nett_profit DESC
LIMIT 10;


-- 5. Jumlah transaksi dan nett sales per bulan
-- Untuk melihat pola musiman
SELECT
  EXTRACT(YEAR FROM date) AS tahun,
  EXTRACT(MONTH FROM date) AS bulan,
  COUNT(transaction_id) AS jumlah_transaksi,
  SUM(nett_sales) AS total_nett_sales
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`
GROUP BY tahun, bulan
ORDER BY tahun, bulan;


-- 6. Pertumbuhan nett sales tahunan per provinsi
-- LAG mengambil nilai tahun sebelumnya untuk membandingkan
WITH penjualan_tahunan AS (
  SELECT
    provinsi,
    EXTRACT(YEAR FROM date) AS tahun,
    SUM(nett_sales) AS total_nett_sales
  FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`
  GROUP BY provinsi, tahun
)
SELECT
  provinsi,
  tahun,
  total_nett_sales,
  LAG(total_nett_sales) OVER (PARTITION BY provinsi ORDER BY tahun) AS nett_sales_tahun_sebelumnya,
  SAFE_DIVIDE(
    total_nett_sales - LAG(total_nett_sales) OVER (PARTITION BY provinsi ORDER BY tahun),
    LAG(total_nett_sales) OVER (PARTITION BY provinsi ORDER BY tahun)
  ) AS pertumbuhan
FROM penjualan_tahunan
ORDER BY provinsi, tahun;


-- 7. Diskon per tahun
SELECT
  EXTRACT(YEAR FROM date) AS tahun,
  AVG(discount_percentage) AS rata_rata_diskon,
  SUM(actual_price * discount_percentage) AS total_nilai_diskon,
  SUM(nett_profit) AS total_nett_profit
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`
GROUP BY tahun
ORDER BY tahun;


-- 8. Performa per kategori cabang
-- Kolom branch_category ada di tabel cabang, jadi perlu digabung
SELECT
  kf_kantor_cabang.branch_category,
  COUNT(DISTINCT kf_analisa.branch_id) AS jumlah_cabang,
  SUM(kf_analisa.nett_sales) AS total_nett_sales,
  AVG(kf_analisa.rating_transaksi) AS rata_rata_rating_transaksi
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`
LEFT JOIN `rakamin-kf-analytics-511302.kimia_farma.kf_kantor_cabang`
  ON kf_analisa.branch_id = kf_kantor_cabang.branch_id
GROUP BY kf_kantor_cabang.branch_category
ORDER BY total_nett_sales DESC;


-- 9. Stok lima cabang dengan rating transaksi terendah
-- Untuk menguji apakah rating rendah disebabkan stok
SELECT
  branch_id,
  COUNT(DISTINCT product_id) AS jumlah_produk,
  SUM(opname_stock) AS total_stok,
  AVG(opname_stock) AS rata_rata_stok
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_inventory`
WHERE branch_id IN (82157, 44567, 13775, 31872, 62707)
GROUP BY branch_id;

-- Pembanding: rata-rata stok seluruh cabang
SELECT AVG(opname_stock) AS rata_rata_stok_semua_cabang
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_inventory`;


-- 10. Jumlah cabang dan nett sales per cabang di tiap provinsi
-- Untuk menguji apakah dominasi Jawa Barat berasal dari jumlah cabang
SELECT
  provinsi,
  COUNT(DISTINCT branch_id) AS jumlah_cabang,
  SUM(nett_sales) AS total_nett_sales,
  SAFE_DIVIDE(SUM(nett_sales), COUNT(DISTINCT branch_id)) AS nett_sales_per_cabang
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`
GROUP BY provinsi
ORDER BY nett_sales_per_cabang DESC;


-- 11. Statistik rating transaksi
-- Untuk menilai apakah selisih rating antar cabang cukup besar atau hanya variasi acak
SELECT
  COUNT(*) AS jumlah_transaksi,
  COUNT(DISTINCT branch_id) AS jumlah_cabang,
  AVG(rating_transaksi) AS rata_rata_rating,
  STDDEV(rating_transaksi) AS simpangan_baku,
  MIN(rating_transaksi) AS rating_terendah,
  MAX(rating_transaksi) AS rating_tertinggi
FROM `rakamin-kf-analytics-511302.kimia_farma.kf_analisa`;
