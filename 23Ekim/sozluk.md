## Sözleşmeler, SOLID prensipleri & OOP mimarşsş
### 1.1 interface`(arayüz/sözleşme)
**Sözlük Anlamı:** iki bağımsız sistemin veya sınıfın birbiriyle nasıl konuşacağını belirleyen içi boş metot imzalarından oluşan kurallar bütünü.
**Neden Kullanılır:** bir sınıfa göbekten bağımlı kalmamak (örneğin gerçek şarj istasyonu cihazı olmadann sahte/mock şarj servisiyle testi çalıştırabilmek ) için.

```dart
abstract interface class StationContreact{
    Future<void> startCharging(String socketId);
    Stream<double> watchLivePower();
}
```

---
## 1.2. `implements` vs `extends` vs `with`

### 1.2.1. `implements` (Arayüz sözleşmesi)
**sözlük anlamı:** bir sınıfın bir şablonun belirlediği kuraları kabul edip **içini sıfırdan kendisinin doldurması** zorunluluğudur.
**Neden kullanılır?** farklı sınıflara ortak bir standart/sözleşme dayatmak, çoklu arayüz desteği sağlamak ve kodda bağımlılıkları azaltmak için.

### 1.2.2. `extends` (Kalıtım/Miras)
**sözlük anlamı:** bir sınıfın başka bir sınıfın özelliklerini ve metotlarını doğrudan devralması.
**Neden kullanılır?** kod tekrarını önlemek (dry), mantıksal bir sınıf hiyerarşisi oluşturmak için.

### 1.2.3. `with` (mixin/yetenek aşılama) 
**Sözlük Anlamı:**  Sınıf hiyerarşisini bozmadan bağımsız bir sınıfa hazır kod blokları (metotlar ve değşkenler) enjekte etme mekanizmasıdır.
**neden kullandık?** Akraba olmayan sınıflara ortak yetenekler kazandırmak, çoklu kalıtım kimliğini önlemek ve modülerliği artırmak için.
---

| Özellik | extends | implements | with |
|---|---|---|---|
| **Temel felsefe** | ben senin çocuğunum, genlerini alıyorum. | seninle sözleşme imzaladım, maddeleri ben yapacağım. | ben ana sınıfıma ek bir uzmanlık yeteneği takıyorum. |
| **gövdesi dolu metot gelir mi** | evet, üst sınıfın metotlarını doğrudan kullanır. | hayır! üst sınıfın içi dolu olsa bile hepsi silinir, sıfırdan yazılır. | evet, mixin içindeki hazır metotlar sınıfa eklenir. |
| **kaç tane kullanılabilir?** | sadece 1 tane (dartta çoklu kalıtım yasaktır). | sınırsız (virgülle onlarca interface uygulanabilir). | sınırsız (virgülle birden çok mixin takılabilir). |
| **Constructor var mıdır** | evet | hayır (interfacein constructor ı olmaz). | hayır. |

---
### 1.3. SOLID Prensipleri (Mobil & Dart Odaklı)
### 1. S -> Single Responsibility Principle (Tek Sorumluluk Prensibi)
**Kural:** Bir sınıfın veya dosyanın değişmesi için **yalnızca bir sebebi** olmalıdır.

### 2. O -> Open / Closed Principle (Açık/Kapalı Prensibi)
**Kural:** yazılım varlıkları (sınıflar, modüller) **genişletilmeye açık ancak değiştirilmeye kapalı** olamlıdır.

## 3. L -> Liskov Substitution Principle (Liskov Yerine Geçme Prensibi)
**Kural:** bir üst sınıfın yerine, onun alt sınıflarından herhangi biri geçirildiğinde sistemin davranışı bozulmamalı ve hata fırlatılmamalıdır.

### 4. I -> Interface Segregation Principle (Arayüz Ayrıştırma Prensibi)
**Kural:** istemciler(sınıflar), kullanmadıkları metotları içermeye zorlanmamalıdır. Şişman(fat) interface'ler yerine küçük, amaca yönelik arayüzler kullanılmalıdır.

### 5. D -> Dependency Inversion Principle (Bağımlılık Tersine Çevirme Prensibi)
**Kural:** yüksek seviyeli modülle (UI, iş mantığı), düşük seviyeli modüllere (Veritabanı, http istemcisi) doğrudan bağımlı olmamalıdır. Her ikisi de soyutlamalara (arayüzlere/interface'lere) bağımlı olmalıdır.
---

### 1.4. `Coupling`(Bağlaşıklık) & `Cohesion`(uyum)
***Tightly Coupled (sıkı bağımlı):*** sınıfların birbirinin her detayını bilmesi. birinde yapılan bir harflik değişiklik diğer 5 dosyayı bozuyorsa sistem sıkı bağımlıdır.

***Loosely Coupled (gevşek bağımlı):*** sınıfların sadece interface üzerinden konuşması. biri değiştiğinde diğeri etkilenmez.

***High Cohesion (yüksek uyum):*** Bir sınıfın sadece ve sadece kendi uzmanlık alanını yapması.
---

## STREAM TEMELLERİ, CUBIT & ENTERPRISE BLOC

### 2.1. `Stream` Nedir? (BLOC'un kalbindeki motor)
***sözlük anlamı:*** zaman içinde parça parça gelen, akıp giden asenkron veri dizisi.
***BLOC SIRRI:*** BLOC kütüphanesi sihirli bir şey yapmaz. BLOC un içinde gizli bir `StreamController`vardır. Event'ler borunun bir ucundan girer (`sink.add`), BLOC onları işler ve diğer ucundan ekrana state akıtır (`stream.listen`).

### 2.2 `Bloc vs Cubit` Karşılaştırması
| kriter | cubit (hafif bloc) | bloc (event-driven)|
|---|---|---|
| Tetikleme Mekanizması | doğrudan metot çağrısı: cubit.loadStations() | Event fırlatma: bloc.add(LoadStationsEvent()) |
| Kod Miktarı | az dosya, sade ve hızlı | event dosyası + state dosyası + bloc dosyası |
|izlenebilirlik (traceability) | sadece hangi fonksiyonun çağırıldığı bilinir | hangi event'in hangi state'e yol açtığı saniye saniye izlenir.|
| event dönüştürücü (debounce/throttle) | elle timer veya flag kurmak gerekir | transformer: restartable() ile tek satırda çözülür.|
|ne zaman tercih edilmeli | basit formlar, tema değiştirme, tab geçişleri, profil| şarj başlatma/bitirme, sepet akışı, bakiye transferi, kimlik doğrulama| 

### 2.3 Bloc'un 3 temel elemanı : `Event`, `State`, `Emitter`
**Event (olay):** kullanıcının veya sistemin bloca attığı emir fişi.
***mini sözdizimi:*** `class StartCargingRequested extends ChargingEvent { final String socketId; }`

**State (durum):** ekranın o milisaniyedeki dondurulmuş fotoğrafı (snapshot). 
***Mini Sözdizimi:*** `class ChargingActiveState extends ChargingState { final double kwh; }`

***Emitter:***  Blocun ürettiği yeni statei ekrana fırlattığı megafon borusu.
***Kural:*** Senkron çalışır; `emit(NewState())` dendiği anda UI'daki builderlar tetiklenir.

---
Soru: State değiştiğinde ne yapmak istiyorsun?
- Sadece Arayüz Çizmek: kart basmak, spinner döndürmek, liste render etmek. -> **BlocBuilder**
- Sadece yan etki tetiklemek: snackBar patlatmak, showDialog() açmakk, sontext.go() ile gitmek. -> **BlocListener**
- Hem arayüz çizmek hem yan etki tetiklemek: hata olunca SnackBar bas, ama listeyi ekranda tut. -> **BlocConsumer**
---

Kullanıcı ekrandayken asenkron işlem başlar (await api.fetchSockets()). Kullanıcı cevap gelmeden geri tuşuna basıp sayfayı kapatır. BLoC/Cubit yok edildiği (closed) için hemen ardından gelen emit() satırı:
StateError: Cannot emit new states after calling close
hatasını fırlatır ve uygulama çöker!
Çözüm: Asenkron await satırından sonraki her emit mutlaka şu şekilde korunmalıdır:
final data = await repository.getData();
if (!isClosed) {
  emit(DataLoaded(data));
}

---

### 3.1. `Side Effect` (Yan Etki) Neden 
* `BlocBuilder` 'ın tek görevi **widget döndürmektir**.
* Flutter motoru ekranı saniyede 60 kez çizilebilir (rebuild). eğer siz `BlocBuilder`içine `ScaffoldMessenger.showSnackBar` veya `Navigator.push` yazarsanız; kullanıcı cihazı yan çevirdiğinde veya klavye açıldığında kullanıcıya **üst üste 10 defa SnackBar patlar veya 10 kez yeni sayfa açılır** 
* **kural:** yan etkiler SADECE `BlockListener`içine yazılır; çünkü `listener`sayfa rebuild olduğunda değil, **yalnızca State değiştiğinde 1 kez** tetiklenir.

---
### 3.2. `BlocSelector`(Mikro Performans & Pil Tasarrufu) 
* **Kavram:** Statein içindeki onlarca alandan sadece **1 tanesini süzüp izlemek**.
---

## 4. EŞİTLİK, DEĞİŞMEZLİK & BLOCOBSERVER 
## 4.1. `Referential Equality` vs `Value Equality`

* **Dart Varsayılanı (referans eşitliği):** İki nesnenin bellekteki (RAM) adresi aynı mı? `Soket('A') == Soket('A')` -> **FALSE çıkar!** İçerikleri aynı olsa da RAM'deki evleri farklıdır.

* **Değer Eşitliği (Value Equality):** Nesnelerin içindeki veriler aynı mı?
`Equatable` paketi tam olarak bunu çözer: Nesneleri RAM adresine göre değil, `props`listesindeki alanların değerine göre karşılaştırır.

### 4.2. `props` Listesi yazılmazsa ne olur?
* Bloc ekran kartını yormamak için şu denetimi yaapr: `if (yeniState == eksiState) ekranCizme();`. 
* Eğer siz `StationLoaded`state'ine yeni bir `filterType` alanı eklerseniz ama `props`içine yazmayı unutursanız; BLoC iki statei eşit zanneder ve **ekranı güncellemez, arayüz donuk kalır**

### 4.3. `Immutability` (Değişmezlik) & `copyWith`
* **Kural:** State sınıflarının tüm alanları `final` olmalıdır (değişmez).
* **`copyWith` Mantığı:** Eski nesnenin 5 alanını koruyup, sadece değişeb 1 alanını günceleyerek taze bir nesne üretme yöntemidir.
    ```dart
    final guncel = state.copyWith(isCharging: true); // Diğer alanlar bozulmadan kopyalanır
    ```
### 4.4. `BlocObserver` (Tüm Uygulamayı Röntgenleme)
* **Kavram:** Uygulamadaki tüm BLoC ve Cubit'lerin arkasında çalışan merkezi bir kara kutu / telemetri kaydedici.
* **Ne İşe Yarar?:** Hangi ekranda hangi Event fırlatıldı, State nereden nereye geçti (`onTransition`) ve nerede hata fırlatıldı (`onError`) tek merkezden konsola loglanır. Kurumsal projelerde analitik ve çökme takibi için zorunludur.

---
### 1. PRESENTATION (Görsel Katman)
- UI ekranları, butonlar, theme, BLoC, Cubit

⬇️ *bağımlılık içeri bakar*

### 2. DOMAIN (İş kuralları - en kutsal katman)
- entity (saf veri), UseCase (iş kuralları)
- Repository Interface (sözleşmeler)
- **Kural!!!** Dış dünyadan (JSON, Dio, SQLite) asla bilgi içermez! Sıfır harici paket importu!

⬆️ *sözleşmeyi uygular*

### 3. DATA (Veri altyapısı)
- Model / DTO (`fromJson` / `toJson`)
- Remote DataSource (Dio ile API)
- Local DataSource (Hive / SharedPreferences ile disk)
- Repository Implementation
---
# 5. CLEAN ARCHITECTURE KATMANLARI & SORUMLULUK DUVARLARI
### 5.1. `Entity` vs `Model` / `DTO`

* **`Entity` (Varlık):** Saf iş nesnesidir. Bir şarj soketinin gerçek hayattaki özelliklerini (`id`, `kw`, `durum`) tutar. `fromJson` veya `toJson` İÇERMEZ.
* **`Model` / `DTO` (Data Transfer Object):** API'den gelen ham JSON verisini karşılayan taşıyıcıdır. `Entity`'den türer; `fromJson` ve `toJson` metotlarını barındırır.
* *"Neden Entity içine `fromJson` yazmıyoruz?"*
    *(Cevap: Yarın backend JSON yerine XML veya Protobuf formatına geçerse; Domain katmanındaki iş kurallarımız ve UI sayfalarımız zerre kadar etkilenmesin, sadece DATA katmanındaki Model etkilensin diye)*

### 5.2. `UseCase` (kullanım senaryosu)
* **Kavram:** Kulanıcının veya sistemin gerçekleştirebileceği **tek ve atomik bir iş kuralı**.
* **Örnekler:** `StartChargingSessionUseCase`, `GetStationSocketUseCase`,`RefundWalletBalanceUseCase`.
* **Kural:** Her UseCase sınıfının içinde sadece tek bir `call()` veya `execute()` fonksiyonu bulunur.

### 5.3. `Repository Contract` vs `Repository Implementation`
* **Contract (Domain Katmanında):** Sadece sözleşmedir (abstract interface class StationRepository). Verinin nereden geleceğini bilmez.
* **Implementation (Data Katmanında):** Sözleşmeyi uygulayan somut sınıftır (class StationRepositoryImpl implements StationRepository). Verinin önce yerel diskten mi yoksa internetten mi çekileceğine karar verir.
---

## 6. BAĞIMLILIK YÖNETİMİ: DEPENDENCY INJECTION & get_it

### 6.1. Neden new Dio() Yazmak Yasaktır?
Eğer 5 ayrı sayfada final dio = Dio(); derseniz:
1. Bellekte 5 ayrı bağlantı havuzu açılır, telefonun soket sınırını zorlar.
2. Base URL veya Timeout değiştiğinde 5 ayrı dosyayı elle değiştirmek zorunda kalırsınız.
3. Test yazarken sahte (mock) veri enjekte edemezsiniz.

### 6.2. GetIt Kayıt Tipleri: Singleton vs LazySingleton vs Factory
* **`Singleton:`** Uygulama açıldığı milisaniyede nesneyi üretir ve belleğe çiviler.
* **`LazySingleton:`** Uygulama açıldığında üretmez! Ne zaman ilk kez birisi `sl<Dio>()` derse o an üretir ve sonrasında hep aynı nesneyi verir. (Bellek ve açılış hızı dostudur).
* **`Factory`:* Her çağrıldığında *yepyeni, sıfır bir kopya* üretir.

## 7. KURUMSAL AĞ MİMARİSİ: DIO, INTERCEPTOR & HTTP STATUS KODLARI
* **Sözlük Anlamı:** Ağ isteği telefondan çıkıp internete gitmeden önce veya sunucudan cevap gelip koda düşmeden önce araya girip paketi inceleyen/değiştiren güvenlik noktası.

### 7.2. `Bearer Token` & `Payload`
* **Bearer Token:** "Bu anahtarı taşıyan kişi giriş yapmaya yetkilidir" anlamına gelen şifrelenmiş kimlik kartı metni (`Authorization: Bearer eyJhbGci...`).
* **Payload:** Bir API isteğiyle sunucuya gönderilen veya sunucudan bize dönen asıl veri gövdesi (Body).


### 7.3. HTTP DURUM KODLARI SÖZLÜĞÜ 
* **`200 OK:`** İstek başarılı, veri gövdede.
* **`201 Created:`** Yeni kayıt (örneğin yeni şarj oturumu) başarıyla oluşturuldu.
* **`400 Bad Request:`** İstemci hatası; eksik veya hatalı parametre gönderdin.
* **`401 Unauthorized:`** Token yok veya süresi dolmuş; hemen Login'e yönlendir!
* **`403 Forbidden:`** Giriş yaptın ama bu veriyi görmeye yetkin yok (Admin değilsin).
* **`404 Not Found:`** Aradığın soket veya istasyon sunucuda bulunamadı.
* **`500 Internal Server Error:`** Backend sunucusu patladı; istemcilik bir hata yok.


## 8. VERİ DAYANIKLILIĞI: CACHE-FIRST & SAVUNMACI KODLAMA

### 8.1. `Cache-First` (Önce Önbellek) Stratejisi
* **Mantık:** Kullanıcı şarj istasyonu listesini açtığında 1 saniye bile beyaz ekranda spinner bekletme! Diskteki dünkü veriyi **0.01 milisaniyede** ekrana bas. Arka planda sunucudan taze veriyi çek; gelince ekranı ve diski sessizce güncelle.

### 8.2. `Defensive Programming` (savunmacı programlama) 
* **Mantık:** Sunucudan gelen veriye asla %100 güvenmeme prensibi.