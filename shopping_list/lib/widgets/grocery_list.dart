import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';


import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';


 class GroceryList extends StatefulWidget{
  const GroceryList ({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
  }

 class _GroceryListState extends State<GroceryList>{
  List<GroceryItem> _groceryItems= [];
  //var _isLoading = true;
  late Future<List<GroceryItem>> _loadedItems; // late ye btayega ki abhi value nai hai lakin bad me value initalize ke jani hai don't worry
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
  }


  //there is meathode for add the + new page which is define the widget that name is (new_item) + (GroceryList )

  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
        'flutter-prep-5798b-default-rtdb.firebaseio.com', 'shopping-list.json');
    // try{
    final response = await http.get(url);

    if(response.statusCode >= 400){
      throw Exception('Failed to fetch data , Please try again later ');

      // setState((){
      //   _error = 'Failed to fetch data , Please try again later ';
      // });
      }


      //when all item deleted then screen will be show continous loading
      if (response.body == 'null'){
        //  setState((){
        //    _isLoading = false;
        //  });
        return [];
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries){
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      return loadedItems;
      //  setState(() {
      //    _groceryItems = _loadedItems;
      //    _isLoading = false;
      //  });

// catch (error){
// setState((){
//   _error = 'Something went wrong !!, Please try again later!!';
// });

//}

}
void _addItem() async {
  final newItem = await Navigator.of(context).push<GroceryItem>(
    MaterialPageRoute(
      builder: (ctx) => const NewItem(),
    ),
  );
  if(newItem == null ){
    return;
  }
  setState((){
    _groceryItems.add(newItem);
  });
}


//jo item add huye use remove krene ke liyevoid _removeItem(GroceryItem item) async{
  void _removeItem(GroceryItem item) async{
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
      });
    final url = Uri.https(
      'flutter-prep-5798b-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400){
    // optional : show error message
      setState(() {
        _groceryItems.insert(index,item);
        });
      }
    }
    @override
    Widget build(BuildContext context){
  //Widget content  = const Center (child : Text('No items added yet.'));
      //if(_isLoading){
      //  content = const Center(child: CircularProgressIndicator());
      //}
      //if (_error != null){
      //  content  = Center (child: Text(_error!));
      // }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),  // next line will add NewList +
          actions:[
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add), //this line will show "+"
              ),
            ],
          ),
          body: FutureBuilder(
            future: _loadedItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
                }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    ),
                  );
                }
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No items added yet.'));
                }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) => Dismissible(
                  onDismissed: (direction) {
                    _removeItem(snapshot.data![index]);
                    },
                  key: ValueKey(snapshot.data![index].id),
                  child: ListTile(
                    title: Text(snapshot.data![index].name),
                     leading: Container(
                       width: 24,
                       height: 24,
                       color: snapshot.data![index].category.color,
                       ),
                       trailing: Text(
                         snapshot.data![index].quantity.toString(),
                         ),
                    ),
                  ),
                );
              },
            ),
        );
      }
  }
