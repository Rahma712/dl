import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dl_app/componant/custom_outline.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'componant/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class MlModel extends StatefulWidget {
  @override
  State<MlModel> createState() => _MlModelState();
}

class _MlModelState extends State<MlModel> {
  Uint8List? result;
  final picker = ImagePicker();
  late Uint8List? imageBytes = null;
  late String base64Image;
  var url = "http://154.183.219.239:5000/api";
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() async {
      if (pickedFile != null) {
        imageBytes = await pickedFile.readAsBytes();
        base64Image = base64Encode(imageBytes!);
      }
    });
  }
  Future<Uint8List?> upload() async {

    if (imageBytes == null) {
      print("Image not found");
      return null;
    }
    late final Response response;
    Map<String,String>requestheaders={'content-type':'application/json','Accept':'application/json',};
    try{
      response = await http.put(Uri.parse(url), headers: requestheaders, body:base64Image,);
    }catch(e){
      print(e);
      return null;
    };
    print("Uploading image to $url");
    print("Image bytes length: ${imageBytes!.lengthInBytes}");
    print("Base64 encoded length: ${base64Image.length}");

    if (response.statusCode == 200) {
      final responseData = await response.bodyBytes;
      return Uint8List.fromList(responseData);
    }
    return null;
  }

  ImageProvider? resultImage() {
    if (result != null) {
      return MemoryImage(result!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Image Colorization', style: TextStyle(color: Constants.kPinkColor),)),
        backgroundColor: Constants.kGreenColor,
      ),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.1,
            left: -88,
            child: Container(
              height: 166,
              width: 166,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 200,
                  sigmaY: 200,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.3,
            right: -100,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 200,
                  sigmaY: 200,
                ),
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: imageBytes != null
                              ? DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.bottomLeft,
                            image: MemoryImage(imageBytes!),
                          )
                              : DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.bottomLeft,
                            image: AssetImage('assets/img-onboarding.png'),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.2,
                        height: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:AssetImage('assets/arrow.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 15.0),
                        child: Row(
                          children: [
                            Container(
                              width: screenWidth * 0.4,
                              height: screenWidth * 0.4,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomLeft,
                                  image: resultImage() ??
                                      AssetImage('assets/img-onboarding.png'),
                                ),
                              ),
                            ),
                            SizedBox(width: screenHeight * 0.05),
                            Container(
                              width: screenWidth * 0.4,
                              height: screenWidth * 0.4,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomLeft,
                                  image: resultImage() ??
                                      AssetImage('assets/img-onboarding.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      Center(
                        child: Padding(
                          padding:  EdgeInsets.only(left: 25.0),
                          child: Row(
                            children: [
                              CustomOutline(
                                strokeWidth: 3,
                                radius: 20,
                                padding: const EdgeInsets.all(3),
                                width: 150,
                                height: 40,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Constants.kPinkColor, Constants.kGreenColor],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Constants.kPinkColor.withOpacity(0.5),
                                        Constants.kGreenColor.withOpacity(0.5)
                                      ],
                                    ),
                                  ),
                                  child:ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Constants.kGreenColor),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20), // Set the border radius here
                                        ),
                                      ),

                                    ),
                                    onPressed: (){
                                      pickImage();
                                    },
                                    child: Text('Pick Image Here',style: TextStyle(
                                      fontSize: 14,
                                      color: Constants.kPinkColor,
                                    )),
                                  ),
                                ),
                              ),


                              SizedBox(
                                width: 10,
                              ),


                              CustomOutline(
                                strokeWidth: 3,
                                radius: 20,
                                padding: const EdgeInsets.all(3),
                                width: 150,
                                height: 40,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Constants.kPinkColor, Constants.kGreenColor],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Constants.kPinkColor.withOpacity(0.5),
                                        Constants.kGreenColor.withOpacity(0.5)
                                      ],
                                    ),
                                  ),
                                  child:ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Constants.kGreenColor,),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20), // Set the border radius here
                                        ),
                                      ),
                                    ),
                                    onPressed: (){
                                      upload();
                                    },
                                    child: Text('Colorize Image',style: TextStyle(
                                      fontSize: 14,
                                      color: Constants.kPinkColor,
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
