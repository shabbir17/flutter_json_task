import 'dart:convert';
import 'package:flutter/material.dart';




class JsonTask extends StatelessWidget {
  // Define the static inputs as variables
  static const String input1 = '[{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]';
  static const String input2 = '[{"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]';

  //TextEditingController searchController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Parser',
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON Parser'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Button to display input 1
              ElevatedButton(
                onPressed: () {
                  // Call the function to parse input 1 and display the titles
                  List<dynamic> parsedJson = parseJson(input1);
                  List<String> titles = extractTitles(parsedJson);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Input 1'),
                        content: Text(titles.join(', ')),
                      );
                    },
                  );
                },
                child: Text('Display Input 1'),
              ),
              // Button to display input 2
              ElevatedButton(
                onPressed: () {
                  // Call the function to parse input 2 and display the titles
                  List<dynamic> parsedJson = parseJson(input2);
                  List<String> titles = extractTitles(parsedJson);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Input 2'),
                        content: Text(titles.join(', ')),
                      );
                    },
                  );
                },
                child: Text('Display Input 2'),
              ),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter ID',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  int id = int.parse(value!);
                  List<dynamic> parsedJson = parseJson(input1);
                  String title = searchById(parsedJson, id);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Object with ID $id'),
                        content: Text(title),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 16.0),
              // Button to search for an object by ID
              ElevatedButton(
                onPressed: () {
                  // Validate and save the ID entered in the text form field
                  final form = Form.of(context);
                  if (form!.validate()) {
                    form.save();
                  }
                },
                child: Text('Search for Object by ID'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to parse the JSON input
  static List<dynamic> parseJson(String jsonString) {
    List<dynamic> parsedJson = json.decode(jsonString);
    return parsedJson;
  }

  // Function to extract the titles from the parsed JSON
  static List<String> extractTitles(List<dynamic> parsedJson) {
    List<String> titles = [];
    for (var obj in parsedJson) {
      if (obj is Map) {
        for (var key in obj.keys) {
          titles.add(obj[key]['title']);
        }
      } else if (obj is List) {
        for (var item in obj) {
          titles.add(item['title']);
        }
      }
    }
    return titles;
  }

  static String searchById(List<dynamic>? parsedJson, int id) {
    String title = '';
    if (parsedJson != null) {
      for (var obj in parsedJson) {
        if (obj is Map) {
          if (obj.containsKey(id.toString())) {
            title = obj[id.toString()]?['title'] ?? '';
            break;
          }
        } else if (obj is List) {
          for (var item in obj) {
            if (item['id'] == id) {
              title = item['title'] ?? '';
              break;
            }
          }
        }
      }
    }
    if (title.isEmpty) {
      title = 'Object with ID $id not found';
    }
    return title;
  }
}