import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sketchzo/data/data.dart';
import 'package:sketchzo/model/wallpaper_model.dart';
import 'package:sketchzo/widgets/widget.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final String searchQuery;
  Search({this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List<WallpaperModel> wallpapers = new List();

  TextEditingController searchController = new TextEditingController();

  getSearchWallpapers(String query)async{

    var response = await http.get("https://api.pexels.com/v1/search?query=$query&per_page=100",
        headers: {
          'Authorization' : apiKEY});
    print(response.body.toString());

    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData['photots'].forEach((element){
      //print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {

    });

  }

  @override
  void initState() {
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 24),
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Row(children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search Wallpapers',
                        border: InputBorder.none
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: (){
                      getSearchWallpapers(searchController.text);

                    },
                    child: Icon(Icons.search)),
              ],),
            ),
            SizedBox(height: 16,),
            wallpaperList(wallpapers : wallpapers, context : context)
          ],
        ),),
      ),

    );
  }
}

