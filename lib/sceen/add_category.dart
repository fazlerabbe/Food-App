import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:admin_app/custom_http/custom_http_request.dart';
import 'package:admin_app/provider/categoryProvider.dart';
import 'package:admin_app/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  File? icon, image;
  TextEditingController nameController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  getIconFromGallery() async {
    final pickerImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickerImage != null) {
      setState(() {
        icon = File(pickerImage.path);
      });
    }
  }

  getImageFromGallery() async {
    final pickerImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickerImage != null) {
      setState(() {
        image = File(pickerImage.path);
      });
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: spinkit,
      opacity: 0.5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Category"),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Enter Category name"),
              ),
              Text("add icon"),
              Container(
                color: icon == null ? Colors.grey : null,
                width: size.width * 0.5,
                height: 150,
                child: icon == null
                    ? InkWell(
                        onTap: () {
                          getIconFromGallery();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.photo), Text("Uploade icon")],
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                image:
                                    DecorationImage(image: FileImage(icon!))),
                          ),
                          Positioned(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    icon = null;
                                  });
                                },
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.red,
                                )),
                            right: 10,
                            top: 0,
                          )
                        ],
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("add image"),
              Container(
                color: image == null ? Colors.grey : null,
                width: size.width * 0.5,
                height: 150,
                child: image == null
                    ? InkWell(
                        onTap: () {
                          getImageFromGallery();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.photo), Text("Uploade icon")],
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(image!),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                  });
                                },
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.red,
                                )),
                            right: 10,
                            top: 0,
                          )
                        ],
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  uploadCategory();
                },
                minWidth: double.infinity,
                height: 50,
                color: Colors.teal,
                child: Text(
                  "Uploade",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  uploadCategory() async {
    try {
      var uri = "${baseUrl}category/store";
      setState(() {
        isLoading = true;
      });
      var request = http.MultipartRequest("POST", Uri.parse(uri));
      request.headers.addAll(await CustomeHttpRequest.getHeaderWithToken());
      request.fields["name"] = nameController.text.toString();
      if (image != null) {
        var img = await http.MultipartFile.fromPath("image", image!.path);
        request.files.add(img);
      }
      if (icon != null) {
        var icn = await http.MultipartFile.fromPath("icon", icon!.path);
        request.files.add(icn);
      }
      var responce = await request.send();
      setState(() {
        isLoading = false;
      });
      var responceData = await responce.stream.toBytes();
      var responceString = String.fromCharCodes(responceData);
      var data = jsonDecode(responceString);
      print("our responce is ${data}");
      print("status code is ${responce.statusCode}");
      if (responce.statusCode == 201) {
        showInToast("category uploaded successfull");
        Provider.of<CategoryProvider>(context, listen: false)
            .getCategoryData(false);
        Navigator.of(context).pop();
      } else {
        showInToast("try again place");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("something is wrong $e");
    }
  }
}
