import 'package:product_favorite/dao/FavoriteDAO.dart';
import 'package:product_favorite/entity/favorite.dart';
import 'package:floor/floor.dart';

//import needed
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
part 'database.g.dart';

@Database(version:1, entities:[Favorite])
abstract class AppDatabase extends FloorDatabase{
  FavoriteDAO get favoriteDao;
}