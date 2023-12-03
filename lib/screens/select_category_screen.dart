
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class SelectCategoryScreen extends StatefulWidget {
  static String routeName = 'select_category_screen';
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
    var categoryName = arguments['categoryName'];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 27,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select category',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length + 1,
            itemBuilder: (context, index) {
              if (index <= snapshot.data!.docs.length - 1) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop<Map<String, dynamic>>(
                        {'categoryName': snapshot.data!.docs[index]});
                  },
                  child: Card(
                    color: categoryName == snapshot.data!.docs[index]['name']
                        ? const Color.fromRGBO(205, 251, 73, 1)
                        : null,
                    elevation: 5,
                    margin: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(snapshot.data!.docs[index]['name']),
                    ),
                  ),
                );
              } else {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).showBottomSheet((context) => Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 3,
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Form(
                            key: formKey,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    controller: categoryController,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        label: const Text('Add Category'),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                        ),
                                        // prefixIcon: Icon(leadingIcon),
                                        prefixIconColor: Colors.black),
                                    cursorColor: Colors.black,
                                    // keyboardType: keyboardType,
                                    style: const TextStyle(color: Colors.black),
                                    validator: (value) {
                                      return categoryValidator(
                                          value, snapshot.data!.docs);
                                    }),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      if (formKey.currentState!.validate()) {
                                        try {
                                          final newCategory =
                                              await FirebaseFirestore.instance
                                                  .collection('categories')
                                                  .add({
                                            'name': categoryController.text,
                                            'userID': FirebaseAuth
                                                .instance.currentUser!.uid,
                                          });
                                          final newCatgeoryDoc = await 
                                              newCategory.get();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Category has been added ')));
                                          // categoryController.clear();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop(
                                              {'categoryName': newCatgeoryDoc});
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text('$e')));
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color.fromRGBO(
                                              207, 255, 71, 1)),
                                      child: const Text(
                                        "Confirm",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                          ),
                          // color: Colors.amber,
                        ));
                  },
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Row(
                          children: [Icon(Icons.add), Text('Add a category')]),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  String? categoryValidator(String? value, List docs) {
    bool categoryAlreadyExists = false;
    print(docs[0]);
    if (value!.isEmpty || value == null) {
      return 'Category cannot be empty';
    } else {
      docs.forEach((element) {
        if (element['name'] == value) {
          categoryAlreadyExists = true;
        }
      });
      if (categoryAlreadyExists) {
        return 'Category already exists';
      }
    }
    return null;
  }
}
