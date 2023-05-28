import 'dart:convert';
import 'dart:io';

import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

import '../custom_http/custom_http_request.dart';

class EditCategoryPage extends StatefulWidget {
  EditCategoryPage({super.key, this.categoryModel});
  CategoryModel? categoryModel;

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  File? icon, image;
  TextEditingController? nameController;
  @override
  void initState() {
    nameController = TextEditingController(text: widget.categoryModel!.name);
    // TODO: implement initState
    super.initState();
  }

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
                        child: Image.network(
                          "${imagebaseUrl}${widget.categoryModel!.icon}",
                          fit: BoxFit.cover,
                        ))
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
                        child: Image.network(
                          "${imagebaseUrl}${widget.categoryModel!.image}",
                          fit: BoxFit.cover,
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
                  updateCategory();
                  //uploadCategory();
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

  updateCategory() async {
    try {
      var uri = "${baseUrl}category/${widget.categoryModel!.id}/update";
      setState(() {
        isLoading = true;
      });
      var request = http.MultipartRequest("POST", Uri.parse(uri));
      request.headers.addAll(await CustomeHttpRequest.getHeaderWithToken());
      request.fields["name"] = nameController!.text.toString();
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
      if (responce.statusCode == 200) {
        showInToast("category uploaded successfull");

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
