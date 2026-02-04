# Analisis Hubungan Produktivitas Jagung dan Luas Lahan di Indonesia

## Project Overview

Proyek ini bertujuan untuk menganalisis hubungan antara produktivititas jagung (ton/ha) dan luas lahan panen (hektar) di tingkat provinsi di Indonesia.
Analisis ini berfokus pada pemahaman apakah peningkatan luas lahan selalu diikuti oleh peningkatan produktivitas, serta mengidentifikasi wilayah dengan efisiensi produksi yang tinggi maupun rendah.
Hasil dari analisis ini diharapkan dapat memberikan insight berbasis data terkait efektivitas pemanfaatan lahan dalam produksi jagung.

## Background
Luas lahan panen sering digunakan sebagai indikator utama kapasitas produksi pertanian.
Namun, produktivitas sebagai hasil per satuan luas lahan tidak selalu sejalan dengan besarnya lahan.
Evaluasi hubungan keduanya penting untuk memahami efisiensi produksi dan potensi peningkatan hasil tanpa perlu ekspansi lahan.

## Analytical Questions
Apakah terdapat hubungan atau korelasi antara luas lahan panen dan produktivitas jagung?
Provinsi mana yang memiliki produktivitas tinggi meskipun luas lahannya relatif kecil?
Bagaimana distribusi provinsi jika dikelompokkan berdasarkan tingkat produktivitas dan luas lahan?

## Data
- **Sumber:** Badan Pusat Statistik (BPS)
- **Periode:** 2020–2024
- **Unit Analisis:** Provinsi
- **Variabel Utama:**
  - Luas Lahan Panen (Ha)
  - Produksi Jagung (Ton)
  - Produktivitas (Ton/Ha)

## Methodology
- Data cleaning dan standarisasi nama wilayah
- Perhitungan produktivitas (Produksi ÷ Luas Lahan)
- Analisis korelasi antara luas lahan dan produktivitas
- Analisis visual menggunakan scatter plot
- Quadrant analysis berbasis nilai median untuk mengelompokkan provinsi

## Tools & Technologies
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook

## Key Findings
- Tidak ditemukan hubungan linier yang kuat antara luas lahan panen dan tingkat produktivitas.
- Beberapa provinsi dengan luas lahan relatif kecil memiliki produktivitas yang tinggi.
- Hal ini menunjukkan bahwa faktor selain luas lahan—seperti manajemen, teknologi, dan varietas—berperan besar dalam meningkatkan produktivitas.

## Visualizations
- **Analisis visual utama meliputi:**
  - Scatter plot hubungan luas lahan dan produktivitas
  - Quadrant plot berbasis median produktivitas dan luas lahan
  - Seluruh visualisasi dapat ditemukan pada notebook analisis dan folder visualisasi.
