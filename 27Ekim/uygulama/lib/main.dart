import 'package:flutter/material.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const MiniMagazaUygulamasi());
}


// StatelessWidget, uygulamamızın temel yapısını oluşturur, değişmeyecek widgetlar için kullanılır.
//StatefulWidget ise, durum değiştirebilen widget'lar için kullanılır.
class MiniMagazaUygulamasi extends StatelessWidget {
  const MiniMagazaUygulamasi({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Mini Mağaza",
      theme:ThemeData(
        useMaterial3: true,
        colorScheme:ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness:Brightness.light,
          
          
        ),
      ),

      //themeof ve themestyle farkı: themeof, temayı alır, themestyle ise temayı kullanır.
      home:const UrunListesiEkrani(),
    );
  }
}
  