import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categories = [];
  bool isFetching = true;

  dynamic fetchAllCategories() async {
    http
        .get(Uri.parse(
            "https://adminapp.tech/Admin/all_apis.php?func=categories"))
        .then((response) {
      dynamic RESPONSE = json.decode(response.body);
      setState(() {
        categories = RESPONSE["categories_response"];
        isFetching = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task1"),
      ),
      body: isFetching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    categories[index]["category_img_url"],
                    width: 40,
                  ),
                  title: Text(categories[index]["category_name"]),
                );
              },
              itemCount: categories.length,
            ),
    );
  }
}
