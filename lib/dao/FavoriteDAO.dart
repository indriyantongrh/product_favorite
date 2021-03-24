import 'package:floor/floor.dart';
import 'package:product_favorite/entity/favorite.dart';

@dao
abstract class FavoriteDAO{
  @Query('SELECT * FROM Favorite WHERE uid=:uid and id=:id')
  Future<Favorite> getFavInFavByUid(String uid, int id);

  @insert
  Future<void> insertFav(Favorite fav);

  @delete
  Future<int> deleteFav(Favorite fav);

}