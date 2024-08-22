import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:task_app/providers/task_provider.dart";
import "package:task_app/task_screen.dart";
//FUNCTION EXPRESSION
void main() {
  runApp(const MyFlutterApp());
}

class MyFlutterApp extends StatelessWidget {
  const MyFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child:
     MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "My Task App",
       theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
         useMaterial3: true,
       ),
        home: const TaskScreen(),
     ),
      );
    //);
  }
}
