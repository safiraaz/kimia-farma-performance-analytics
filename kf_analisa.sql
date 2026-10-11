-- Membuat tabel analisa Kimia Farma 2020-2023
-- Gabungan tabel transaksi, kantor cabang, dan produk
CREATE OR REPLACE TABLE `rakamin-kf-analytics-511302.kimia_farma.kf_analisa` AS
SELECT
  kf_final_transaction.transaction_id,
  kf_final_transaction.date,
  kf_final_transaction.branch_id,
  kf_kantor_cabang.branch_name,
  kf_kantor_cabang.kota,
  kf_kantor_cabang.provinsi,
  kf_kantor_cabang.rating AS rating_cabang,
  kf_final_transaction.customer_name,
  kf_final_transaction.product_id,
  kf_product.product_name,
  kf_final_transaction.price AS actual_price,
  kf_final_transaction.discount_percentage,

  -- Persentase laba berdasarkan rentang harga obat
  CASE
    WHEN kf_final_transaction.price <= 50000 THEN 0.10
    WHEN kf_final_transaction.price <= 100000 THEN 0.15
    WHEN kf_final_transaction.price <= 300000 THEN 0.20
    WHEN kf_final_transaction.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Harga setelah diskon
  kf_final_transaction.price * (1 - kf_final_transaction.discount_percentage) AS nett_sales,

  -- Keuntungan = harga setelah diskon x persentase laba
  kf_final_transaction.price * (1 - kf_final_transaction.discount_percentage) *
  CASE
    WHEN kf_final_transaction.price <= 50000 THEN 0.10
    WHEN kf_final_transaction.price <= 100000 THEN 0.15
    WHEN kf_final_transaction.price <= 300000 THEN 0.20
    WHEN kf_final_transaction.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  kf_final_transaction.rating AS rating_transaksi

FROM `rakamin-kf-analytics-511302.kimia_farma.kf_final_transaction`
LEFT JOIN `rakamin-kf-analytics-511302.kimia_farma.kf_kantor_cabang`
  ON kf_final_transaction.branch_id = kf_kantor_cabang.branch_id
LEFT JOIN `rakamin-kf-analytics-511302.kimia_farma.kf_product`
  ON kf_final_transaction.product_id = kf_product.product_id;
