# MoneyPlan - Geliştirme ve Takip Dokümanı

**Proje Adı:** MoneyPlan  
**Platform:** Flutter & Dart (iOS Simulator, macOS, Android)  
**Tasarım Dili:** Editorial Finance + Dreamy Money (Material Design 3, Orman Yeşili, Sıcak Krem, Kırık Beyaz, Lila, Pastel Sarı)  
**Tarih:** 21 Ekim 2026  
**Durum:** ✅ Tamamlandı & iOS Simülatöründe Başarıyla Çalışıyor  

---

## 1. Mimari ve Sayfa Yapısı

Uygulama `project.md`, `agents/skills/SKILL.md` ve `project-taslak.md` içerisindeki tüm gereksinimleri karşılayacak şekilde 5 ana sekme ve modal formlardan oluşmaktadır:

### 1.1. Genel Bakış (Dashboard) - `OverviewTab`
- **Akıllı Bütçe Kartı (`UsableMoneyCard`):**
  - Formül: `Kullanılabilir Para = Mevcut Bakiye - Yaklaşan Zorunlu Ödemeler - Ayrılmış Birikim - Korunacak Güvence Payı`
  - Günlük ve haftalık önerilen harcama tutarları
  - Katlanabilir formül detay dökümü
- **Finansal Özet Kartları (`StatSummaryCards`):** Aylık Gelir, Gider ve Birikim toplamları
- **Money Wrapped Kartı:** Yıl/Ay sonu alışkanlık ve başarı hikaye deneyimi
- **Aylık Genel Bütçe İlerlemesi (`BudgetProgressCard`):** Limite yaklaşma (%80) ve aşım (%100) uyarıları
- **Öne Çıkan Birikim Hedefi (`VisionBoardCard`):** Öncelik, motivasyon notu, hedef ilerleme yüzdesi ve hızlı para yatırma
- **Yaklaşan Düzenli Ödemeler (`RecurringItem`):** Kalan gün sayısı, aciliyet rozetleri ve ödendi toggle aksiyonu
- **Son İşlemler Listesi:** En son hareketler, düzenleme ve onaylı silme

### 1.2. İşlemler - `TransactionsTab`
- **Filtreleme & Arama:**
  - Anlık metin araması (başlık, kategori, not)
  - Tür filtreleme (Hepsi / Gelir / Gider / Birikim)
  - İstek vs. İhtiyaç (Need / Want) harcama ayrımı
- **Dinamik Sıralama:** Tarihe göre (en yeni/en eski), tutara göre (azalan/artan)
- **İşlem Ekleme / Düzenleme Formu (`AddTransactionSheet`):**
  - Başlık, Tutar, Kategori, Tarih, Gelir/Gider/Birikim, İstek mi İhtiyaç mı seçimi, Not
  - Doğrulama (boş alan engeli, negatif ve sıfır tutar koruması)
- **Silme İşlemi:** Yanlışlıkla silinmeyi önleyen onay diyaloğu ve SnackBar bildirimi

### 1.3. Analizler & Raporlar - `AnalyticsTab`
- **Kategori Bazlı Harcama Dağılımı (`EditorialDonutChart`):** Flutter CustomPainter ile özel tasarım, bağımlılıksız halka grafik ve dinamik etiketler
- **Haftalık Harcama Trendi (`WeeklyBarChart`):** Son 7 günün gün bazlı harcamaları ve tepe noktası vurgusu
- **İhtiyaç vs. İstek Harcama Analizi:** Zorunlu giderler ile keyfi harcamaların oranı
- **Akıllı Harcama Yorumu:** Harcama yoğunluğuna göre dinamik tavsiye ve değerlendirme
- **Gelecek Ay Bütçe Önerileri:** Geçmiş harcamalardan beslenen kategori bütçe dağıtım rehberi
- **Paylaşılabilir Finansal Karne:** Tasarruf oranı ve aylık özet

### 1.4. Hayallerim & Vision Board - `DreamsTab`
- **Dreamy Vision Board:** İlham veren kartlar, ikon ve kategori seçimi
- **Hedef Belirleme & Düzenleme (`AddGoalSheet`):** Hedef tutar, mevcut birikim, öncelik derecesi (1-3) ve motivasyon sözü
- **Hedefe Hızlı Birikim Ekleme (`DepositGoalDialog`):** Tek dokunuşla birikim yapma ve otomatik işlem geçmişine kaydetme

### 1.5. Bütçe ve Düzenli Ödemeler - `BudgetsTab`
- **Aylık Kategori Bütçeleri:** Genel Bütçe, Market, Yemek, Giyim vb. limitler ve limit aşım bildirimleri
- **Abonelikler ve Düzenli Ödemeler Takvimi:** Kira, fatura, Netflix, Spotify, spor salonu
- **Aylık Sabit & Zorunlu Gider Toplamı:** Kullanıcının aylık minimum sabit yükü
- **Abonelik Ekleme Formu (`AddRecurringSheet`):** Hızlı şablonlar ve gün seçici kaydırıcı

---

## 2. Tasarım Sistemi ve Temalar

- **Tasarım Dili:** Editorial Finance + Dreamy Money
- **Açık Tema (Dreamy Cream):**
  - Arka plan: Sıcak krem (`#FAF7F2`)
  - Kartlar: Kırık beyaz (`#FFFFFF`) ve yumuşak kenarlıklar (`#E7DEC8`)
  - Vurgular: Orman yeşili (`#1E5638`), Rüya lilası (`#9D84B7`), Pastel sarı (`#F7D965`)
- **Koyu Tema (Editorial Emerald):**
  - Derin zümrüt ve gece ormanı (`#0F1A15`, `#192922`)
  - Kartlar: `#192922`, sınır çizgileri `#2E483C`
  - Vurgular: Nane yeşili (`#8FD5A6`), Açık lila (`#EAE2F8`)
- **Geçiş:** AppBar üzerinden tek dokunuşla anlık tema değişimi ve kalıcı saklama.

---

## 3. Veri Yönetimi ve Kalıcılık

- `shared_preferences` entegrasyonu ile yerel JSON saklama (`LocalStorageService`).
- İlk açılışta zengin ve gerçekçi `DemoData` otomatik yüklenir.
- Kullanıcı dilediğinde AppBar menüsünden "Demo Verilerine Sıfırla" seçeneği ile verileri başlangıç haline döndürebilir.
- Tüm bakiye, grafik ve formül verileri işlemlerden dinamik olarak hesaplanır.

---

## 4. Doğrulama ve Canlı Çalıştırma

- `flutter analyze`: **0 issue** (hatasız, uyarısız tertemiz analiz).
- `flutter test`: **Tüm testler başarıyla geçti (All tests passed)**.
- iOS Simülatör: `iPhone 17` üzerinde uygulama canlı olarak derlendi ve başarıyla çalıştırıldı.
- **Düzeltme & İyileştirme:** "Yeni İşlem Ekle" formundaki İstek / İhtiyaç seçicisinde oluşan 9.8 piksellik sağ taşma (Right Overflow) sorunu giderildi; seçim alanı responsive, tam genişlikli ve dokunmatik alanı geniş çift buton mimarisine yükseltildi. Canlı olarak simülatörde doğrulandı.
