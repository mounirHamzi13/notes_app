// // ignore_for_file: unused_import

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:anim_search_bar/anim_search_bar.dart';
// import 'package:notes_app_ui/providers/searchedValue.dart';
// import 'package:provider/provider.dart';

// class CustomAppBar extends StatefulWidget {

//   const CustomAppBar(
//     {
//     super.key,
//   });

//   @override
//   State<CustomAppBar> createState() => _CustomAppBarState();
// }

// class _CustomAppBarState extends State<CustomAppBar>
//     with SingleTickerProviderStateMixin {
//   late FocusNode _focusNode;
//   // AnimationController? _controller;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _focusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _focusNode.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     var searchedText = Provider.of<SearchedText>(context, listen: true);
//     // print(searchedText.text);
//     // print(widget._textEditingController.text);
//     // // widget._textEditingController.addListener(_oncChanged);
//     // // void _onChanged() {

//     // // }
//     return SliverAppBar(
//       automaticallyImplyLeading: false,
//       titleSpacing: 27,
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       title: _focusNode.hasFocus ? null : delayWidget(),
//       actions: [
//         Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Focus(
//             focusNode: _focusNode,
//             child: Stack(children: [
//               AnimSearchBar(
//                   animationDurationInMilli: 200,
//                   autoFocus: true,
//                   width: MediaQuery.of(context).size.width * 0.96,
//                   textController: searchedText.textEditingController,
//                   onSuffixTap: () {},
//                   onSubmitted: (value) {}),
//             ]),
//           ),
//           // child: Icon(
//           //   CupertinoIcons.search,
//           //   color: Colors.black,
//           //   size: 25,
//           // ),
//         ),
//         // Padding(
//         //   padding: EdgeInsets.only(top: 15, right: 20, left: 10),
//         //   child: Badge(
//         //       alignment: Alignment.topRight,
//         //       child: Icon(
//         //         CupertinoIcons.bell,
//         //         color: Colors.black,
//         //         size: 25,
//         //       )),
//         // )
//       ],
//     );
  
//   }

//   Widget delayWidget() {
//     Future.delayed(Duration(milliseconds: 300));
//     return Row(
//       children: [
//         // const CircleAvatar(
//         //   backgroundImage: NetworkImage(
//         //       'https://i.pinimg.com/236x/d5/fc/5c/d5fc5cd3f13aac0361a4f2479edc1379.jpg'),
//         // ),
//         Stack(children: [
//           RichText(
//               text: TextSpan(children: [
//             TextSpan(
//                 text: ' Welcome Back ',
//                 style: Theme.of(context).textTheme.bodyMedium),
//             TextSpan(
//                 text: 'Mounir', style: Theme.of(context).textTheme.bodyLarge)
//           ])),
//         ]),
//         Padding(
//           padding: const EdgeInsets.only(left: 5.0),
//           child: Image.network(
//             'https://em-content.zobj.net/source/apple/354/waving-hand_1f44b.png',
//             height: 25,
//           ),
//         )
//       ],
//     );
//   }

// }
