import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError=(errordetails){
        FirebaseCrashlytics.instance.recordFlutterFatalError(errordetails);
    };

    PlatformDispatcher.instance.onError=(error,stack){
        FirebaseCrashlytics.instance.recordError(error,stack,fatal: true);
        return true;
    };
    runApp(const SoftitoCrashApp());

    
}


