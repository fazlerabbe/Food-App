import 'dart:convert';

import 'package:admin_app/custom_http/custom_http_request.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/provider/categoryProvider.dart';
import 'package:admin_app/sceen/add_category.dart';
import 'package:admin_app/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

import '../edit_category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryData(isLoading);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var category = Provider.of<CategoryProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddCategory(),
          ));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: SingleChildScrollView(
          //physics: ,
          //physics: PageScrollPhysics(),
          //physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Text("Category"),
              SizedBox(
                height: 10,
              ),
              category.categoryList.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 220,
                          child: Column(
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                alignment: Alignment.bottomRight,
                                //color: Colors.green,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          "${imagebaseUrl}${category.categoryList[index].image}",
                                        ),
                                        fit: BoxFit.cover)),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      "${imagebaseUrl}${category.categoryList[index].icon}"),
                                ),
                              ),
                              Text(
                                "${category.categoryList[index].name}",
                                style: myStyle(
                                    22, Colors.black26, FontWeight.bold),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Icon(Icons.edit),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EditCategoryPage(
                                              categoryModel:
                                                  category.categoryList[index],
                                            ),
                                          ))
                                          .then((value) =>
                                              Provider.of<CategoryProvider>(
                                                      context,
                                                      listen: false)
                                                  .getCategoryData(true));
                                    },
                                  ),
                                  InkWell(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("are you sure"),
                                            content:
                                                Text("you want to delete data"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    bool isDelete =
                                                        await CustomeHttpRequest
                                                            .deleteCategoryData(
                                                                id: category
                                                                    .categoryList[
                                                                        index]
                                                                    .id);
                                                    print(
                                                        "is delete value is $isDelete");
                                                    Navigator.of(context).pop();
                                                    showInToast(
                                                        "category deleted successfull");
                                                    if (isDelete == true) {
                                                      showInToast(
                                                          "category delete successful");
                                                      setState(() {
                                                        category.categoryList
                                                            .removeAt(index);
                                                      });
                                                    } else {
                                                      showInToast(
                                                          "category not deleted please try again");
                                                    }
                                                  },
                                                  child: Text("Delete")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("No"))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: category.categoryList.length,
                      shrinkWrap: true,
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
