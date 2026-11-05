import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/storage_ve_fcm_ekrani.dart';

void main() async{
  //bu servisleri başlatmadan sayfayı başlatma
  WidgetsFlutterBinding.ensureInitialized();

  try{
    await Firebase.initializeApp();
  } catch (_) {
    runApp(const SoftitoFcmDemoApp());
  }
}

  class SoftitoFcmDemoApp extends StatelessWidget{
    const SoftitoFcmDemoApp({super.key});

    @override
    Widget build(BuildContext context){
      return MaterialApp(   
        debugShowCheckedModeBanner: false,
        title: "Softito FCM Demo App",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(0,0,0,0),
          brightness: Brightness.light,
          ),
          useMaterial3: true;
        ),
        home: const StorageVeFcmEkrani(),
      );
    }
  }
