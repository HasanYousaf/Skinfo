import 'package:camera/camera.dart';
import 'package:final_project/AccessDB.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/product.dart';
import 'text_detector_view.dart';
import 'package:final_project/AccessDB.dart';
import 'AccessDB.dart';

var db;
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AccessDB().initDB();
  Future<List<Product>> futureProducts = AccessDB().getProducts();
  List<Product> products = await futureProducts;
  print (products[0].toString());

  cameras = await availableCameras();

  runApp(MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Welcome Back!"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 200, height: 150, child: Text('Logo goes here')),
              ),
            ),
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Email'),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Password'),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
            //Add navigation to sign up page
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Welcome Back!"),
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => TextRecognizerView()));
                      },
                      child: const Text(
                        'Scan Product Label',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => {},
                        child: Text('Search By Name',
                            style: TextStyle(color: Colors.white, fontSize: 25)))
                  ]));
        }));
  }
}


// class FirstScreen extends StatelessWidget {
//   const FirstScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Center(
//             child: ElevatedButton(
//       onPressed: () => Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => const NewScreen())),
//       child: const Text('Second Screen'),
//     )));
//   }
// }

// class NewScreen extends StatefulWidget {
//   const NewScreen({Key? key}) : super(key: key);
//
//   @override
//   State<NewScreen> createState() => _NewScreenState();
// }
//
// class _NewScreenState extends State<NewScreen> {
//   TextEditingController textEditingController = TextEditingController();
//
//   @override
//   void dispose() {
//     textEditingController.dispose();
//     // ignore: avoid_print
//     // print('Dispose used');
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text('Second Screen'),
//           backgroundColor: Colors.blue,
//         ),
//         // Avoid unnecessary containers
//         body: Container(
//             child: Center(
//                 child: ElevatedButton(
//           onPressed: () => Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) => const FirstScreen())),
//           child: const Text('First Screen'),
//         ))));
//   }
// }
