1. SQL CRUD İşlemleri

# ----USERS TABLOSU OLUŞTURMA----
CREATE TABLE IF NOT EXISTS users(
id INTEGER PRIMARY KEY AUTOINCREMENT,
fullname TEXT NOT NULL,
email TEXT UNIQUE NOT NULL)

- Sonuç : burada sonuç olarak içi boş olan 3 sütunlu bir tablo oluşur.

# ----TABLOYA KULLANICI EKLEME----
INSERT INTO users(fullname,email) VALUES 
('zelal dartan','zelal@gmail.com'),
('ayşe onur','ayse@gmail.com'),
('arda demir','ada@gmail.com');

- Sonuç: create ile oluşturduğumuz boş tabloya veri ekleriz şöyle gözükür,

id	fullname	Email
1	zelal dartan	zelal@gmail.com
2	ayşe onur	ayse@gmail.com
3	arda demir	ada@gmail.com

# ----KULLANICILARI LİSTELEME----
SELECT * FROM users;

- Sonuç:  Tablodaki tüm verileri listeleyebiliriz. Çıktı şu şekilde gelir,

id	fullname	Email
1	zelal dartan	zelal@gmail.com
2	ayşe onur	ayse@gmail.com
3	arda demir	ada@gmail.com

# ----BİR KULLANICININ MAİLİNİ DÜZENLEME----
UPDATE users SET email='arda@gmail.com' WHERE id=3;

- Sonuç: id si 3 olan kullanıcının mailini arda@gmail.com olarak değiştirdik sonucunda tabloda değişir şu şekilde,

id	fullname	Email
1	zelal dartan	zelal@gmail.com
2	ayşe onur	ayse@gmail.com
3	arda demir	arda@gmail.com

# ----BİR KULLANICI SİLME----
DELETE FROM users WHERE id=3;

- Sonuç: id si 3 olan kullanıcıyı tablodan sildik sonucunda tablonun son hali,

id	fullname	Email
1	zelal dartan	zelal@gmail.com
2	ayşe onur	ayse@gmail.com


2. INNER JOIN

-Öncelikle inner join iki tabloyu aralarındaki ortak bilgi üzerinden birleştirmemizi sağlar. bu iki tablonun ortak bilgisi id, iki tabloyu id üzerinden birleştiricez.

1- Önce SELECT ile istenen bilgileri çekicez. (users tablosundan adı ve maili, orders tablosundan sipariş numarasını.)
-> SELECT users.fullname, users.email, orders.orderNo
2- users tablosundan başlayarak bilgileri alıcaz.
-> FROM users
3- sonra orders tablosundan istediğimiz bilgiyi alıcaz
-> INNER JOIN orders
4- Burası en önemli kısım bence. Bu iki tabloyu hangi alana göre alacağımızı ON a yazıyoruz.
-> ON users.id = orders.user_id

# ----TAM SORGU----
SELECT users.fullname, users.email, orders.orderNo 
FROM users 
INNER JOIN orders 
ON users.id = orders.user_id;


3. MOBİL UYGULAMA GÜVENLİĞİ

# a) Ekran görüntüsü ve ekran kaydı
Bir bankacılık uygulamasında kredi kartı bilgileri veya bakiye gösterilirken ekran görüntüsü alınmasını ve ekran kaydı yapılmasını engellemek neden önemlidir?

- kredi kartı bilgileri ve bakiye gibi veriler hassas verilerdir, bunların kaydedilmesi hassas bilgilerin açığa çıkmasına neden olabilir. engellemek bu yüzden önemlidir. Androidde bunun için FLAG_SECURE kullanılır.

# b) Overlay saldırıları
Bir saldırganın başka bir uygulamanın üzerine sahte bir buton veya ekran yerleştirerek kullanıcıyı yanıltması nasıl gerçekleşebilir?

- Saldırganın uygulaması gerçek uygulamanın üzerine sahte ekran koyar, kullanıcı gerçek uygulamada olduğunu zannedip bilgisini sahte ekrana girer ve bilgi saldırgana gider. Ya da sahte bir buton koyar mesela kullanıcıya hediye çeki kazandınız diye ekran gelir hediye çekini al diyebuton vardır kullanıcı ona tıklar ama aslında o butona tıklayınca para transfer et butonuna tıklamış olur.

# c) Root / Jailbreak
Root edilmiş veya Jailbreak yapılmış bir cihaz neden normal bir cihaza göre daha risklidir?

- Telefon işletim sistemleri bazı alanları uygulamalardan korur yani bi uygulama sistem dosyalarına ya da başka uygulama verilerine erişemez. Ama root ve jailbreak cihazın normalde kısıtlı alanlarına yüksek yetkiyle erişim sağlayabilir. Bu yüzden bankacılık gibi uygulamarda riskli bir ortam olur. örneğin saldırgan access token ı ele geçirmeye çalışabilir ya da hassas verilere ulaşabilir.

# d) SQLite ve şifreleme
Normal bir SQLite veritabanında kullanıcı bilgilerinin düz metin olarak bulunmasının ne gibi bir riski vardır? SQLCipher gibi bir çözüm kullanıldığında ne değişir?

- SQLite veritabanında bilgilerin düz metin olrk tutulması veritabanı dosyasına erişen saldırganın verileri okuyabilmesine neden olur. SQLCipher da veritabanı şifrelenerek saklanır ve dosyaya erişilse bile bilgiler okunamaz. bu yüzden daha güvenli olur.

# e) Access Token ve Refresh Token
Access Token ile Refresh Token arasındaki farkı kendi cümlelerinizle açıklayın.
- acces token kullanıcının apilere erişmesini sağlar ve kısa sürelidir. refresh token ise access tokenın süresi dolduğunda yeni almak için kullanılır daha uzun süre geçerlidir.

->	Access Token neden kısa süreli tutulabilir?
- çünkü çalınabilir. çalınsa bile sınırsız süre vermeyelim mantığıyla kısa süre verilir.

->  Refresh Token neden daha güvenli bir yerde saklanmalıdır?
- çünkü daha uzun ömürlüdür (30 gün). eğer çalınırsa saldırgan sürekli yeni access tokenlar üretebilir. Bu yüzden daha güvenli saklanmalıdır.

->	Kullanıcı çıkış yaptığında neden Refresh Token iptal edilebilir?
- çünkü eğer biri bu tokenı ele geçirirse yeni access token almaya çalışabilir.