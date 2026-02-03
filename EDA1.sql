create table df1 
(provinsi varchar(50),
Tahun int,
Luas_Panen decimal(12,2),
Produktivitas decimal(12,2),
Produksi decimal(12,2)
);

select * from df1 limit 200;

--ubah satuan pada kolom produktivitas

update df1 
set produktivitas  = produktivitas * 0.1;


--melihat rataan yield provinsi
select provinsi, round(avg(produktivitas),2) as rataan_5_tahun from df1 group by provinsi order by rataan_5_tahun desc;

--yoy yield
CREATE VIEW yoy_produktivitas AS
SELECT
    provinsi,
    tahun,
    produktivitas,
    ROUND(
        (produktivitas - LAG(produktivitas)
         OVER (PARTITION BY provinsi ORDER BY tahun))
        / NULLIF(
            LAG(produktivitas)
            OVER (PARTITION BY provinsi ORDER BY tahun), 0
        ) * 100,
        2
    ) AS yoy_pct
FROM df1;
SELECT
    provinsi,
    MAX(CASE WHEN tahun = 2021 THEN yoy_pct END) AS yoy_20_21,
    MAX(CASE WHEN tahun = 2022 THEN yoy_pct END) AS yoy_21_22,
    MAX(CASE WHEN tahun = 2023 THEN yoy_pct END) AS yoy_22_23,
    MAX(CASE WHEN tahun = 2024 THEN yoy_pct END) AS yoy_23_24
FROM yoy_produktivitas
GROUP BY provinsi
ORDER BY provinsi;

COPY (
    SELECT * FROM yoy_produktivitas
) TO 'C:/data/COBA PROJECT/DATA/yoy_produktivitas.csv' CSV HEADER;

--yoy area
CREATE VIEW YOY AS
SELECT
  provinsi,
  AVG(produktivitas) AS avg_produktivitas,
  AVG(yoy_yield_pct) AS avg_yoy_yield,
  AVG(luas_panen) AS avg_luas_panen,
  AVG(yoy_area_pct) AS avg_yoy_area
FROM (
  SELECT
    provinsi,
    tahun,
    produktivitas,
    luas_panen,

    -- YoY produktivitas (AMAN)
    (produktivitas - LAG(produktivitas)
        OVER (PARTITION BY provinsi ORDER BY tahun))
    / NULLIF(
        LAG(produktivitas)
        OVER (PARTITION BY provinsi ORDER BY tahun),
        0
      ) * 100 AS yoy_yield_pct,

    -- YoY luas panen (AMAN)
    (luas_panen - LAG(luas_panen)
        OVER (PARTITION BY provinsi ORDER BY tahun))
    / NULLIF(
        LAG(luas_panen)
        OVER (PARTITION BY provinsi ORDER BY tahun),
        0
      ) * 100 AS yoy_area_pct

  FROM df1
) t
GROUP BY provinsi
ORDER BY provinsi;
COPY (
    SELECT * FROM YOY
) TO 'C:/data/COBA PROJECT/DATA/YOY.csv' CSV HEADER;


--melihat perkembangan yield dari 2020-2024
CREATE VIEW yield_growth AS 
WITH ordered AS (
    SELECT
        provinsi,
        tahun,
        produktivitas
    FROM df1
),
baseline AS (
    SELECT
        provinsi,
        MIN(tahun) AS first_active_year
    FROM ordered
    WHERE produktivitas > 0
    GROUP BY provinsi
),
joined AS (
    SELECT
        o.provinsi,
        o.tahun,
        o.produktivitas,
        b.first_active_year
    FROM ordered o
    JOIN baseline b ON o.provinsi = b.provinsi
)
SELECT
    provinsi,
    MAX(CASE WHEN tahun = first_active_year THEN produktivitas END) AS baseline_yield,
    MAX(CASE WHEN tahun = 2024 THEN produktivitas END) AS yield_2024,
    ROUND(
        (
            MAX(CASE WHEN tahun = 2024 THEN produktivitas END)
            -
            MAX(CASE WHEN tahun = first_active_year THEN produktivitas END)
        )
        /
        NULLIF(
            MAX(CASE WHEN tahun = first_active_year THEN produktivitas END),
            0
        ) * 100,
        2
    ) AS growth_since_start
FROM joined
GROUP BY provinsi
ORDER BY growth_since_start DESC;

COPY (
    SELECT * FROM yield_growth
) TO 'C:/data/COBA PROJECT/DATA/VISUALISASI/yield_growth.csv' CSV HEADER;

--melihat perkembangan luas lahan dari 2020-2024
CREATE VIEW Area_growth AS 
WITH ordered AS (
    SELECT
        provinsi,
        tahun,
        luas_panen
    FROM df1
),
baseline AS (
    SELECT
        provinsi,
        MIN(tahun) AS first_active_year
    FROM ordered
    WHERE luas_panen > 0
    GROUP BY provinsi
),
joined AS (
    SELECT
        o.provinsi,
        o.tahun,
        o.luas_panen,
        b.first_active_year
    FROM ordered o
    JOIN baseline b ON o.provinsi = b.provinsi
)
SELECT
    provinsi,
    MAX(CASE WHEN tahun = first_active_year THEN luas_panen END) AS baseline_area,
    MAX(CASE WHEN tahun = 2024 THEN luas_panen END) AS area_2024,
    ROUND(
        (
            MAX(CASE WHEN tahun = 2024 THEN luas_panen END)
            -
            MAX(CASE WHEN tahun = first_active_year THEN luas_panen END)
        )
        /
        NULLIF(
            MAX(CASE WHEN tahun = first_active_year THEN luas_panen END),
            0
        ) * 100,
        2
    ) AS growth_since_start
FROM joined
GROUP BY provinsi
ORDER BY growth_since_start DESC;

COPY (
    SELECT * FROM Area_growth
) TO 'C:/data/COBA PROJECT/DATA/VISUALISASI/Area_growth.csv' CSV HEADER;

--hitung koefisien variansi
create view CV AS 
SELECT
    provinsi,
    ROUND(
        STDDEV_POP(produktivitas) / NULLIF(AVG(produktivitas), 0),
        2
    ) AS cv_yield
FROM df1
GROUP BY provinsi;
COPY (
    SELECT * FROM CV
) TO 'C:/data/COBA PROJECT/DATA/VISUALISASI/CV.csv' CSV HEADER;


--MELIHAT KORELASI YIELD DENGAN LUAS PANEN
create view Correlation AS 
SELECT
    provinsi,
    CORR(produktivitas, Luas_Panen) AS corr_yield_area
FROM df1 
GROUP BY provinsi order by corr_yield_area DESC;
COPY (
    SELECT * FROM Correlation
) TO 'C:/data/COBA PROJECT/DATA/VISUALISASI/Correlation.csv' CSV HEADER;





