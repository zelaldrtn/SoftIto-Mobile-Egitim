4 tablo yapacağız çünkü her bilginin kendi yerinde durmasını istiyoruz yani bölümler tablosunda sadece bölüm bilgileri, öğrenciler tablosunda sadece öğrenci bilgileri, dersler tablosunda da derslerin bilgileri olacak. Bir bölümde biçok öğrenci olabileceği için öğrenci tablosunda bolumId ile bölümü bağlicaz. Bir bölümde birçok ders, bir ders de bir çok bölümde olabileceği için bölüm ders arasındaki ilişki çoka çok oluyor (N:M) bunun için de BolumDers tablosunu oluşturacağız. Böylece 3NF e uygun olacak.


# Bölümler Tablosu
CREATE TABLE bolumler(
    bolumId INTEGER PRIMARY KEY AUTOINCREMENT,
    bolumAd TEXT NOT NULL
);

# Öğrenciler Tablosu
CREATE TABLE ogrenciler(
    ogrId INTEGER PRIMARY KEY AUTOINCREMENT,
    ogrAd TEXT NOT NULL,
    bolumId INTEGER NOT NULL,
    FOREIGN KEY (bolumId) REFERENCES bolumler(bolumId) 
    <!--öğrenciler tablosundaki bolumId, bolumler tablosundaki bolumIDyi referans alsın-->
);

# Dersler Tablosu
CREATE TABLE dersler(
    dersId INTEGER PRIMARY KEY AUTOINCREMENT,
    dersAd TEXT NOT NULL
);

# Bölüm-Ders Tablosu
CREATE TABLE bolumDers(
    bolumId INTEGER NOT NULL,
    dersId INTEGER NOT NULL,
    PRIMARY KEY (bolumId, dersId),
    FOREIGN KEY (bolumId) REFERENCES bolumler(bolumId),
    FOREIGN KEY (dersId) REFERENCES dersler(dersId)
);