import 'package:flutter/material.dart';
import 'package:shopping_list/models/category.dart';

///data -> categories.dart **
///data -> dummy_items.dart

const categories = {
  Categories.vegetables: Category(
    'Vegetable', 				///title
    Color.fromARGB(255, 0, 255, 128),		///color
  ),
  Categories.fruit: Category(
    'fruit',
    Color.fromARGB(255,145,255,0),
  ),
  Categories.meat: Category(
    'meat',
    Color.fromARGB(255,255,102,0),
  ),
  Categories.dairy: Category(
    'dairy',
    Color.fromARGB(255,0,208,255),
  ),
  Categories.carbs: Category(
    'carbs',
    Color.fromARGB(255,0,60,255),
  ),
  Categories.sweets: Category(
    'sweets',
    Color.fromARGB(255,225,149,0),
  ),
  Categories.spices: Category(
    'spices',
    Color.fromARGB(255,225,187,0),
  ),
  Categories.convenience: Category(
    'convenience',
    Color.fromARGB(255,191,0,255),
  ),
  Categories.hygiene: Category(
    'hygiene',
    Color.fromARGB(255,149,0,255),
  ),
  Categories.other: Category(
    'other',
    Color.fromARGB(255,0,255,255),
  ),
};