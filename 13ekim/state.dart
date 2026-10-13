/*1. createState()

2. mounted == true

3. initState()

4. didChangeDependencies() (widget değişimlerinde tetiklenir(Thema.of(context) bu adımda güvenli olarak çalıştırılır))

5. build(BuildContext context) (UI burda döndürür (ASLA İÇİNDE ASENKRON İŞLEM YAPILMAZ))

6. didUpdateWidget(oldWidget) ( üst ebeveyn yeni bir parametre yolladığında çalışır)

7. deactive() (ağaçtan geçici olarak kopma)

8. dispose() (kalıcı olarak kapatma (controller.dispose Stream.cancel) burda yapılır )

9. mounted == false


//BUNU İYİCE ANLAMAKK ÖDEVVVVV

*/