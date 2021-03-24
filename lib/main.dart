import 'dart:convert';
import 'dart:ffi';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:product_favorite/const/const.dart';
import 'package:product_favorite/dao/FavoriteDAO.dart';
import 'package:product_favorite/database/database.dart';
import 'package:product_favorite/entity/favorite.dart';
import 'package:product_favorite/model/product.dart';
import 'package:flutter/services.dart' as rootBundle;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('edmt_favorite.db').build();
  final dao = database.favoriteDao;
  runApp(MyApp( dao : dao));
}

class MyApp extends StatelessWidget {
  final FavoriteDAO dao;

  MyApp({this.dao});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Favorite', dao:dao),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.dao}) : super(key: key);
  final FavoriteDAO dao;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future:  readJsonDatabase(),
        builder: (context, snapshot){
          if(snapshot.hasError)
            return Center(child: Text('${snapshot.error}'),);
          else if (snapshot.hasData)
            {
              var items = snapshot.data as List<Product>;
              return ListView.builder(
                  itemCount: items == null ? 0 : items.length,
                  itemBuilder: (context, index){

                    return Card(
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: ClipRRect(
                              child: Image(image: NetworkImage(items[index].imageUrl),
                              fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ), flex: 2,),
                            Expanded(child: Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(items[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 2, overflow: TextOverflow.ellipsis,),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8),
                                    child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('\$${items[index].price}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            maxLines: 2, overflow: TextOverflow.ellipsis,),
                                          FutureBuilder(
                                              future: checkFav (items[index]),
                                              builder: (context, snapshot){
                                                if(snapshot.hasData)
                                                  return IconButton(icon: Icon(Icons.favorite, color: Colors.red,),
                                                      onPressed: () async{
                                                      final item = snapshot.data as Favorite;
                                                      await widget.dao.deleteFav(item);
                                                      setState(() {

                                                      });
                                                      });
                                                      else
                                                        return IconButton(icon: Icon(Icons.favorite, ),
                                                            onPressed: () async{
                                                          Favorite fav = new Favorite(
                                                            id:  items[index].id,
                                                            imageUrl: items[index].imageUrl,
                                                            name: items[index].name,
                                                            uid: UID
                                                          );
                                                          await widget.dao.insertFav(fav);
                                                          setState(() {

                                                          });
                                                            });

                                              })
                                        ],
                                      )
                                   ),
                                ],
                              ),
                            ),flex: 6,)
                          ],
                        ),
                      ),
                    );

              });
            }
          else return Center(child: CircularProgressIndicator(),);
        },

      ),
    );
  }

  Future<List<Product>> readJsonDatabase() async{
    final rawData = await rootBundle.rootBundle.loadString('load_json/load_json.json');
    final list = json.decode(rawData) as List<dynamic>;
    return list.map((e) => Product.fromJson(e)).toList();
  }

  Future <Favorite> checkFav (Product item) async{
    return await widget.dao.getFavInFavByUid(UID, item.id);
  }
}
