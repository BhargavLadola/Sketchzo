import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;

  ImageView({@required this.imgUrl});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  var filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Hero(
          tag: widget.imgUrl,
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(widget.imgUrl, fit: BoxFit.cover,)),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  _save();

                },
                child: Stack(children: <Widget>[
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2,
                      color: Color(0xff1C1B1B).withOpacity(0.8),
                  ),
                  Container(
                    height: 50,
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54, width: 1),
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF)
                          ])
                      ),
                      child:Column(children: <Widget>[
                        Text('Set Wallpaper',style: TextStyle(
                            fontSize: 10, color: Colors.white),),
                        Text('Image will be saved in gallery',style: TextStyle(
                            fontSize: 10, color: Colors.white
                        ),),
                      ],)
                  ),
                ],),
              ),
              SizedBox(height: 10,),
           Text('Cancel', style: TextStyle(color: Colors.white),),
              SizedBox(height: 50,)

        ],),)
      ],),
    );
  }

//  _save() async {
//    await _askPermission();
//
////    var response = await Dio().get(widget.imgUrl,
////        options: Options(responseType: ResponseType.bytes));
////    final result =
////    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
////    print(result);
////    Navigator.pop(context);
//  }

  void _save() async {
    await _askPermission();
    final dir = await getExternalStorageDirectory();
    print(dir);
    Dio dio = new Dio();
    dio.download(
      widget.imgUrl,
      "${dir.path}/wallbay.png",
      onReceiveProgress: (received, total) {
        if (total != -1) {
          String downloadingPer =
          ((received / total * 100).toStringAsFixed(0) + "%");
          print("Downlaed:: "+downloadingPer);
//          setState(() {
//            downPer = downloadingPer;
//          });
        }
//        setState(() {
//          downloadImage = true;
//        });
      },
    ).whenComplete(() {
//      setState(() {
//        downloadImage = false;
//      });
      initPlatformState("${dir.path}/wallbay.png");
//      Navigator.pop(context);
    });
  }

  Future<void> initPlatformState(String path) async {
    String wallpaperStatus = "Unexpected Result";
    String _localFile = path;
    try {
      Wallpaperplugin.setWallpaperWithCrop(localFile: _localFile);
      wallpaperStatus = "Wallpaper set";
    } on PlatformException {
      print("Platform exception");
      wallpaperStatus = "Platform Error Occured";
    }
    if (!mounted) return;
  }

  _askPermission() async {
    if (Platform.isIOS) {
      Map<Permission, PermissionStatus> permissions = await [
        Permission.photos,
      ].request();
//      Map<Permission, PermissionStatus> permissions;
//          await PermissionHandler()
//          .requestPermissions([PermissionGroup.photos]);
    } else {
      PermissionStatus permission = await Permission.storage.status;
//       PermissionStatus permission = await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.storage);
    }
  }
}



