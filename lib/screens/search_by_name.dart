import 'package:final_project/screens/ingredients_view.dart';
import 'package:flutter/material.dart';

class SearchByName extends StatefulWidget {
  const SearchByName({Key? key}) : super(key: key);

  @override
  State<SearchByName> createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Search", textAlign: TextAlign.center),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Text(
                      'Search By Name',
                      textScaleFactor: 3.2,
                      style: TextStyle(color: Colors.blue),
                    )),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.blue),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Product Name',
                    hintText: 'Product Name'),
              ),
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => IngredientsView(scanned: searchController.text)));
                },
                child: const Text(
                  'Search',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            //Add navigation to sign up page
          ],
        ),
      ),
    );
  }
}