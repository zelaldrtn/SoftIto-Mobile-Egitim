# Klavye ve Metin Girişi Sorunu Analiz ve Kontrol Raporu (kontrol.md)

Bu döküman, uygulamadaki klavye ve metin alanlarına yazı yazma sırasında yaşanan kasma, odak kaybı ve yerleşim sorunlarının kök neden analizini, uygulanan çözümleri ve test doğrulama sonuçlarını detaylandırmaktadır.

---

## 1. Tespit Edilen Kök Nedenler (Root Cause Analysis)

### A. Arama Çubuğunda Debounce Olmaması ve Her Tuşta Senkron Liste Yeniden Çizimi
- **Sorun:** `CarSearchBar` bileşeni her tuş vuruşunda (`onChanged`) doğrudan `CarController.instance.searchQueryNotifier.value = val` tetikliyordu. Bu tetikleme, filtreleme fonksiyonunu çalıştırıp anında `filteredCarsNotifier` üzerinden tüm araç vitrinini (`ListView.builder`, kartlar ve ağ görselleri) ana iş parçacığında (UI thread) yeniden çiziyordu.
- **Sonuç:** Kullanıcı hızlı yazı yazarken her harfte liste baştan derlendiği için klavyede donma, gecikmeli tuş vuruşu ve kasma meydana geliyordu.

### B. Form Ekranlarında `Center` ile `SingleChildScrollView` Çakışması
- **Sorun:** Özellikle `LoginView` ekranında `Center(child: SingleChildScrollView(...))` yapısı kullanılmıştı.
- **Sonuç:** Mobil klavye açılıp kapanırken ekranın kullanılabilir yüksekliği (`viewInsets.bottom`) animasyonlu olarak değişir. `Center` bileşeni form alanını dikeyde ortalamaya çalışırken, `SingleChildScrollView` odaklanan metin alanını görünür alana kaydırmaya çalışır. Bu iki yerleşim mekanizması klavye animasyonu boyunca birbiriyle yarışarak (layout thrashing) ekranın titremesine, kasmasına ve metin alanının odak kaybetmesine yol açıyordu.

### C. Eksik FocusNode ve Odak / Eylem Zinciri Eksikliği
- **Sorun:** `TextFormField` bileşenlerinde `focusNode`, `textInputAction` (`TextInputAction.next`, `TextInputAction.done`) ve `onFieldSubmitted` tanımlı değildi.
- **Sonuç:** Kullanıcı bir alandan diğerine geçerken klavye kapanıp açılıyor, kullanıcı bir sonraki alana geçemiyor veya klavye açıkken boş alana dokunulduğunda klavye kapatılamıyordu.

### D. Form İçi `setState` Kullanımının Tüm Alanları Yeniden Tetiklemesi
- **Sorun:** `AddEditCarView` içerisinde yakıt, vites veya kategori seçildiğinde sayfa genelinde `setState` çağrılıyordu. Bu durum tüm metin alanlarının ve kontrolcülerin bulunduğu üst widget'ı gereksiz yere baştan çiziyordu.
- **Sonuç:** Yazı girişi esnasında veya seçimlerde gereksiz build döngüleri oluşuyordu.

---

## 2. Uygulanan Çözümler

1. **Arama Çubuğuna Debounce ve Bağımsız Denetleyici:**
   - `CarSearchBar` içine 250ms'lik bir geciktirme (debounce timer) eklendi.
   - Hızlı yazımda her harfte anında liste çizimi engellendi; kullanıcı yazmayı bitirdiğinde filtreleme akıcı şekilde çalışacak hale getirildi.
   - Arama kutusuna hızlı temizleme butonu (`x`) ve `TextInputAction.search` eklendi.

2. **Dengeli ve Kararlı Kaydırma Mimarisi:**
   - `LoginView`'daki `Center` çakışması `LayoutBuilder` + `ConstrainedBox` + `IntrinsicHeight` mimarisiyle değiştirildi. Klavye animasyonu esnasında layout thrashing ortadan kaldırıldı.
   - Form sayfalarına `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag` eklendi; liste kaydırıldığında klavye akıcı şekilde kapanır.
   - Sayfa geneline `GestureDetector` ile dışarı dokunulduğunda odağı kaldırma (`FocusScope.of(context).unfocus()`) sağlandı.

3. **Tam Odak Zinciri (FocusNodes & TextInputAction):**
   - Giriş (`LoginView`), Araç Ekle/Düzenle (`AddEditCarView`) ve Rezervasyon oluşturma (`CreateReservationView`) formlarındaki tüm alanlara `FocusNode`'lar tanımlandı ve `dispose` metotlarında bellekten temizlendi.
   - Alanlar arası geçişler için `TextInputAction.next` ve son alanda `TextInputAction.done` bağlandı; klavyedeki "Sonraki" tuşuyla akıcı geçiş sağlandı.

4. **Dropdown Seçimlerinin Reaktif Ayrımı:**
   - `AddEditCarView` içerisindeki açılır menüler sayfa düzeyinde `setState` yerine doğrudan hafif durum yönetimiyle izole edildi; yazı yazarken formun gereksiz yeniden çizilmesi engellendi.

5. **Türkçe Açıklayıcı Kod Yorumları:**
   - Controller'lar (`CarController`, `ReservationController`, `AuthController`), veri modelleri (`Car`, `Reservation`, `UserProfile`), form validasyonları, tema yönetimi ve navigasyon mantığı proje kurallarına uygun şekilde Türkçe yorum satırlarıyla belgelendi.

---

## 3. Ekran ve Form Kontrol Durumları

| Ekran / Bileşen | Form Alanları | Focus & Klavye Durumu | Validasyon Mantığı | Test Sonucu |
| :--- | :--- | :--- | :--- | :--- |
| **Giriş / Kayıt** (`LoginView`) | E-posta, Şifre | `_emailFocus`, `_passFocus`, `TextInputAction.next/done`, Unfocus | E-posta regex doğrulaması, şifre $\ge 6$ karakter | **BAŞARILI** |
| **Araç Arama** (`CarSearchBar`) | Arama Metni | 250ms Debounce, Temizleme (`x`), `TextInputAction.search` | Anlık harf filtrelemesi debounce ile optimize edildi | **BAŞARILI** |
| **Araç Ekle/Düzenle** (`AddEditCarView`) | Marka, Model, Yıl, Ücret, URL, Açıklama | 6 adet FocusNode zinciri, `keyboardDismissBehavior: onDrag` | Boşluk, sayısal format ve URL zorunluluk kontrolleri | **BAŞARILI** |
| **Rezervasyon Oluşturma** (`CreateReservationView`) | Ehliyet Sınıfı, Ehliyet Yılı | `_classFocus`, `_yearFocus`, `textCapitalization: characters` | Araç minimum ehliyet sınıfı ve tecrübe yılı kontrolü, tarih çakışması | **BAŞARILI** |

---

## 4. Test ve Analiz Raporu

- **`flutter analyze`:** `0 issues found!` (Tüm linter kuralları eksiksiz karşılandı).
- **`flutter test`:** 7/7 test senaryosu başarıyla geçti (`test/widget_test.dart`).
- **Simülatör Durumu:** iPhone 17 (iOS 26.0) üzerinde uygulama çalışır durumda; klavye açılma ve kaydırma hareketleri akıcı olarak doğrulandı.

---

## 5. Araç Sahibi Buton Çakışması ve Kendi Aracını Kiralama Düzeltmesi

1. **Araç Ekle & Düzenle Butonlarının Üst Üste Binmesi:**
   - **Kök Neden:** `MyCarsView` sayfasında sağ altta sabit duran `FloatingActionButton.extended` ("Araç Ekle"), listenin altındaki kartın sağ alt köşesinde bulunan "Düzenle" butonunun tam üzerine denk gelerek tıklanmasını engelliyordu.
   - **Çözüm:** Sağ alttaki engelleyici FAB kaldırıldı. "Araç Ekle" butonu üst AppBar'a şık ve belirgin bir `FilledButton.icon` olarak taşındı. Araç kartlarındaki "İlanı Kaldır" (sol) ve "Düzenle" (sağ) butonları `spaceBetween` ile dengeli bir şekilde yerleştirildi. Böylece hiçbir buton üst üste binmez.

2. **Araç Sahibinin Kendi Aracını Kiralama Durumu:**
   - **Kök Neden:** `CarDetailView` ekranındaki alt çubuk tüm kullanıcılara sabit olarak "Hemen Kirala" butonu gösteriyordu. Araç sahibi kendi ilanına tıkladığında da kiralama formu açılıyordu.
   - **Çözüm:** `CarDetailView` dinamik hale getirildi:
     - İncelenen araç aktif kullanıcıya aitse (veya araç sahibi modundaysa), alt çubukta "Kendi İlanınız" rozeti ve **"İlanı Düzenle"** butonu gösterilir; tıklandığında `AddEditCarView(car: car)` açılır.
     - İncelenen araç başka bir kullanıcıya aitse kiralayan için **"Hemen Kirala"** butonu gösterilmeye devam eder.
     - `CreateReservationView` içine de güvenlik kontrolü eklenerek kendi aracını kiralamaya çalışma engellendi.
     - `test/widget_test.dart` içine "Senaryo 12" eklenerek bu davranış otomatik test ile doğrulandı.

