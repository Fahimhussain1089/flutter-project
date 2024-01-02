

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart';

import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};


class TabsScreen extends ConsumerStatefulWidget{
  const TabsScreen ({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}
class _TabsScreenState extends ConsumerState<TabsScreen>{
  int _selectPageIndex = 0;




  //
  // void _toggleMealFavoriteStatus(Meal meal){
  //   final isExisting = _favoriteMeals.contains(meal);
  //
  //   if(isExisting ){
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showInfoMessage('Meal is no longer a favorites');
  //     }else{
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //     });
  //   }
  // }


  void _selectPage(int index){
    setState(() {
      _selectPageIndex= index;
    });
  }

 void  _setScreen(String  identifier) async {
   Navigator.of(context).pop();
    if(identifier == 'filters'){
     final result = await Navigator.of(context).push<Map<Filter,bool>>(
          MaterialPageRoute(
              builder: (ctx) => const FiltersScreen(),
          ),
      );
     }
 }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage =   CategoriesScreen(
     availableMeals:availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectPageIndex== 1){
      final favoritesMeals = ref.watch(favoriteMealsProvider);
      activePage =  MealsScreen(
        meals: favoritesMeals,

      );
      activePageTitle= 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),

        drawer:  MainDrawer(onSelectScreen: _setScreen,),

          body: activePage,
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            currentIndex: _selectPageIndex,

            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.set_meal),label:'Categories', ),
              BottomNavigationBarItem(icon: Icon(Icons.star),label:'Favorites' ,),
            ],
          )

    );
  }

}