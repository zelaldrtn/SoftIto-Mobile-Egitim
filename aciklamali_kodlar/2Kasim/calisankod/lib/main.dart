import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/ana_kasa.dart';
import 'screens/vitrin.dart';
import 'screens/profil.dart';

// uygulamanın giriş noktası
void main() {
  runApp(const MyApp());
}

// kök widget
class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    // MaterialApp temel yönlendirme ve görsel temayı sağlar
    return MaterialApp(
      home:AnaKasaEkrani(ekranGovdesi:VitrinEkrani()),
    );
  }
}

// GoRouter ile modern sayfa yönlendirmesi ve alt kabuk (ShellRoute) rotalarını yapılandırıyoruz
final GoRouter uygulamaRotalari=GoRouter(
    initialLocation:'/anasayfa',
    routes:[
        // ShellRoute alt sayfalar değişse bile ortak alt barı (AnaKasaEkrani) sabit tutar
        ShellRoute(
            builder: (BuildContext context, GoRouterState state, Widget child){
                return AnaKasaEkrani(ekranGovdesi:child);
            },
            routes:[
                GoRoute(
                    path:'/vitrin',
                    builder:(context,state)=>const VitrinEkrani(),
                ),
                GoRoute(
                    path:'/profil',
                    builder:(context,state)=>const ProfilEkrani(),
                ),
            ],
        ),
    ],
);

