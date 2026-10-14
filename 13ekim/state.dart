/*1. createState()    //Ekranın durumunu yönetecek nesne oluşturulur.

2. mounted == true  //Ekran uygulamanın içinde aktif olrk duruyor. Ekran mevcut ve bağlı.

3. initState()    //İlk açılış hazırlığı burada yapılır. Bunları ilk açılışta yaparız her ekran çizildiğinde yapmayız.

4. didChangeDependencies()      //Kullanılan bazı bilgiler değişti. Ekranın kullanıldığı tema bilgisi değiştiğinde bu metot çalışabilir

5. build(BuildContext context)    //Ekranı çiz ve göster. Yeniden çizilmesi gerekirse tekrar çalışabilir

6. didUpdateWidget(oldWidget)   //Eski ekranın yönetimini koruyup yeni bilgi gönderiyorsak çalışır. Aynı ekranın bilgileri güncellendiğinde.

7. deactive()     //Ekran bulunduğu yerden geçici olrk ayrılıyor. Ekranın kesin olrk silindiği anlamına gelmez. Tekrar kullanılabilir.

8. dispose()    //Ekran kapanırken temizlik yapar. Artık kullanılmayan controller temizlenir.

9. mounted == false   //Ekran tamamen kaptıldı. Bağlantı bitti. State nesnesi bağlı değil.


//BUNU İYİCE ANLAMAKK ÖDEVVVVV

*/