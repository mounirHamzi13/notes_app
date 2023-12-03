// ignore_for_file: unused_import

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:notes_app_ui/providers/searchedValue.dart';
import 'package:notes_app_ui/widgets/hashtag_all_widget.dart';
import 'package:notes_app_ui/widgets/notes_card.dart';
import 'package:notes_app_ui/widgets/notes_grid.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/your_notes_widget.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  late bool onlyOnce;
  // List<QueryDocumentSnapshot> searchedList = [];
  String username = '';
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    onlyOnce = false;
    fetchUsername();
  }

  @override
  void dispose() {
    _tabController
        .dispose(); // Dispose of the TabController when the widget is removed
    super.dispose();
    _focusNode.dispose();
    _textEditingController = TextEditingController();
  }

  Widget delayWidget() {
    Future.delayed(Duration(milliseconds: 300));
    return Row(
      children: [
        // const CircleAvatar(
        //   backgroundImage: NetworkImage(
        //       'https://i.pinimg.com/236x/d5/fc/5c/d5fc5cd3f13aac0361a4f2479edc1379.jpg'),
        // ),
        Stack(children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: ' Welcome Back ',
                style: Theme.of(context).textTheme.bodyMedium),
            TextSpan(
                text: username, style: Theme.of(context).textTheme.bodyLarge)
          ])),
        ]),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Image.asset(
            'assets/waving_emoji.png',
            height: 25,
          ),
        )
      ],
    );
  }

  Future<void> fetchUsername() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userDoc.data()!.containsKey('username')) {
      setState(() {
        username = userDoc['username'];
      });
    }
  }

  var dropDownButtonValue = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .where('userID',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, categoriesSnapshot) {
            if (categoriesSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            _tabController = TabController(
                length: categoriesSnapshot.data!.docs.length + 1, vsync: this);
            return DefaultTabController(
              length: categoriesSnapshot.data!.docs.length,
              child: CustomScrollView(
                slivers: [
                  Builder(builder: (context) {
                    // fetchUsername();
                    return SliverAppBar(
                      automaticallyImplyLeading: false,
                      titleSpacing: 27,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: _focusNode.hasFocus ? null : delayWidget(),
                      // actions: [
                      //   Padding(
                      //     padding: EdgeInsets.all(8.0),
                      //     child: Focus(
                      //       focusNode: _focusNode,
                      //       child: Stack(children: [
                      //         AnimSearchBar(
                      //             animationDurationInMilli: 200,
                      //             autoFocus: true,
                      //             width:
                      //                 MediaQuery.of(context).size.width * 0.96,
                      //             textController: _textEditingController,
                      //             onSuffixTap: () {},
                      //             onSubmitted: (value) async {
                      //               print("valueeeeeeeeee");

                      //               final titleDocs = await FirebaseFirestore
                      //                   .instance
                      //                   .collection('notes')
                      //                   .where('title', isEqualTo: value)
                      //                   .get()
                      //                   .then((titleSnapshot) async {
                      //                 print(
                      //                     "titleSnapshot length ///////////////////////////////////////");
                      //                 print(titleSnapshot.docs.length);
                      //                 final contentDocs =
                      //                     await FirebaseFirestore.instance
                      //                         .collection('notes')
                      //                         .where('content',
                      //                             arrayContains: value)
                      //                         .get()
                      //                         .then((contentSnapshot) {
                      //                   print(
                      //                       "contentSnapshot length /////////////////////////////////////");
                      //                   print(contentSnapshot.docs.length);
                      //                   List<QueryDocumentSnapshot>
                      //                       combinedResult = [];
                      //                   combinedResult
                      //                       .addAll(titleSnapshot.docs);
                      //                   combinedResult
                      //                       .addAll(contentSnapshot.docs);

                      //                   setState(() {
                      //                     searchedList = combinedResult;
                      //                     print(searchedList);
                      //                   });
                      //                 });
                      //               });
                      //             }),
                      //       ]),
                      //     ),
                      //     // child: Icon(
                      //     //   CupertinoIcons.search,
                      //     //   color: Colors.black,
                      //     //   size: 25,
                      //     // ),
                      //   ),
                      //   // Padding(
                      //   //   padding: EdgeInsets.only(top: 15, right: 20, left: 10),
                      //   //   child: Badge(
                      //   //       alignment: Alignment.topRight,
                      //   //       child: Icon(
                      //   //         CupertinoIcons.bell,
                      //   //         color: Colors.black,
                      //   //         size: 25,
                      //   //       )),
                      //   // )
                      // ],

);
                  }),

                  YourNotesWidget(),
                  // SliverToBoxAdapter(
                  //   child: Padding(
                  //     padding:
                  //         const EdgeInsets.only(top: 20, left: 20, right: 20),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Container(
                  //           width: 180,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(12),
                  //             color: Colors.grey.shade300,
                  //           ),
                  //           child: DropdownButton(
                  //               isExpanded: true,
                  //               icon: const Icon(
                  //                 Icons.keyboard_arrow_down,
                  //                 color: Colors.black,
                  //               ),
                  //               // icon: Icon(CupertinoIcons.chevron_down),
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyMedium!
                  //                   .copyWith(
                  //                       color: Colors.black,
                  //                       fontWeight: FontWeight.bold),
                  //               padding:
                  //                   const EdgeInsets.symmetric(horizontal: 10),
                  //               // borderRadius: BorderRadius.circular(20),
                  //               // dropdownColor: Colors.grey,
                  //               underline: Container(),
                  //               value: dropDownButtonValue,
                  //               items: const [
                  //                 DropdownMenuItem(
                  //                   value: 0,
                  //                   child: Text('All'),
                  //                 ),
                  //                 DropdownMenuItem(
                  //                   value: 1,
                  //                   child: Text('Work'),
                  //                 ),
                  //                 DropdownMenuItem(
                  //                   value: 2,
                  //                   child: Text('Personal'),
                  //                 ),
                  //                 DropdownMenuItem(
                  //                   value: 3,
                  //                   child: Text('Fitness'),
                  //                 ),
                  //                 // DropdownMenuItem(
                  //                 //   value: 'All',
                  //                 //   child: Text('All'),
                  //                 // ),
                  //               ],
                  //               onChanged: (value) {
                  //                 print(value);
                  //                 setState(() {
                  //                   dropDownButtonValue = value!;
                  //                 });
                  //               }),
                  //         ),
                  //         SizedBox(
                  //           width: 55,
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               SvgPicture.asset('assets/svgs/icon.svg'),
                  //               const Icon(
                  //                 Icons.menu,
                  //                 color: Colors.grey,
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  
                    SliverToBoxAdapter(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('notes')
                              .where('userID',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              // .doc('categories')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                child: TabBar(
                                  controller: _tabController,
                                  // onTap: (value) {
                                  //   setState(() {
                                  //     dropDownButtonValue = value;
                                  //   });
                                  // },
                                  // controller: tabController,
                                  labelPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  indicator: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(205, 251, 73, 1),
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(12)),
                                  labelColor: Colors.black,
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  physics: const BouncingScrollPhysics(),
                                  isScrollable: true,
                                  tabs: [
                                        const Tab(key: Key('All'), text: 'All')
                                      ] +
                                      categoriesSnapshot.data!.docs
                                          .toList()
                                          .map((e) => Tab(text: e['name']))
                                          .toList(),
                                ),
                              );
                            }
                            // print("/////////////////////////////////////////////");
                            // print("this is the data ${snapshot.data!.docs.toList()}");
                          }),
                    ),
                  
                    SliverFillRemaining(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TabBarView(
                            controller: _tabController,
                            children: [const HashtagAllWidget()]
                                    .cast<Widget>() +
                                categoriesSnapshot.data!.docs
                                    .map((e) => NotesGrid(category: e['name']))
                                    .toList()
                                    .cast<Widget>()),
                      ),
                    )
                ],
              ),
            );
          }),
    );
  }

  // Future<List<Widget>> fetchCategories() async {
  //   var categories =
  //       await FirebaseFirestore.instance.collection('categories').get();
  //   return categories.docs.toList().map((element) { return Text(element['name']) }).toList() ;
  // }
}
