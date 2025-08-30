import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD3jR71dEWvb-f_at37EVFKAAKJi876rm0",
      authDomain: "controle-estoque-1b8c4.firebaseapp.com",
      databaseURL: "https://controle-estoque-1b8c4-default-rtdb.firebaseio.com",
      projectId: "controle-estoque-1b8c4",
      storageBucket: "controle-estoque-1b8c4.firebasestorage.app",
      messagingSenderId: "228138986569",
      appId: "1:228138986569:web:271675fcdb0140cf212398",
      measurementId: "G-K7DLBQ8DPN",
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Estoque',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

