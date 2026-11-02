//setState() bulunduğu State nesnesinin build() metodunu baştan aşağı tekrar tetikler.
//Scaffold appbar tabbar ve eğer varsa 20 tane container baştan hesaplanır.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/ana_kasa.dart';
import 'screens/vitrin.dart';
import 'screens/profil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:AnaKasaEkrani(ekranGovdesi:VitrinEkrani()),
    );
  }
}


final GoRouter uygulamaRotalari=GoRouter(
    initialLocation:'/anasayfa',
    routes:[
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