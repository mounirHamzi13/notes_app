import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:notes_app_ui/mixins/harmonized_colors.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_ui/screens/write_notes_screen.dart';
import 'package:popover/popover.dart';

class NoteCard extends StatelessWidget {
  QuillController _controller;
  Color color;
  String title;
  Timestamp? createdAt;
  List content;
  String id;
  String category;
  // double width;
  // double height;
  NoteCard({
    super.key,
    required this.color,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.category,
    required this.id,
  }) : _controller = QuillController(
            document: Document.fromJson(content),
            selection: TextSelection(baseOffset: 0, extentOffset: 0));

  @override
  Widget build(BuildContext context) {
    // _controller.document = Document.fromJson(content).toPlainText() ;
    return InkWell(
      onLongPress: () {
        showPopover(
            context: context,
            // onPop: ,
            bodyBuilder: (context) => InkWell(
                onTap: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('notes')
                        .doc(id)
                        .delete();
                    // Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Something went wrong')));
                  }
                  Navigator.of(context).pop() ;
                },
                child: ListTile(
                  leading: Text('Delete'),
                  trailing: Icon(Icons.delete),
                )),
            width: 150);
      },
      onTap: () {
        Navigator.pushNamed(context, WriteNoteScreen.routeName, arguments: {
          'id': id,
          'title': title,
          'content': content,
          'createdAt': createdAt,
          'category': category
        });
      },
      child: Align(
        alignment: Alignment.bottomLeft, // Adjust alignment as needed
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          width: /* 180 */ MediaQuery.sizeOf(context).width * 0.45,
          height: /* 245 */ MediaQuery.of(context).size.height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  DateFormat('d MMMM y').format(createdAt!.toDate()),
                  // createdAt!.toDate().toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: Colors.grey.shade900,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),

                child: Text(
                  Document.fromJson(content).toPlainText(),
                  overflow: TextOverflow.fade,
                  maxLines: 6,
                ),
                // child: QuillEditor(
                //   scrollController: ScrollController(),
                //       controller: _controller,
                //       scrollable: false,
                //       autoFocus: false,
                //       padding: const EdgeInsets.all(0),
                //       focusNode: FocusNode(),
                //       readOnly: true,
                //       expands: false,
                //       showCursor: false,
                //   // placeholder: content,
                //   // content ,
                //   // style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                //   //   fontWeight: FontWeight.w800,
                //   //       color: Colors.grey.shade900,
                //   //       fontSize: 15,
                //   //     ),
                // ),
              ),
              const Spacer(),
              const FlutterLogo(
                textColor: Colors.pink,
                style: FlutterLogoStyle.markOnly,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
// class NoteCard extends StatelessWidget {
//   Color color;
//   double width;
//   double height;
//   NoteCard({
//     super.key,
//     required this.color,
//     this.height = 250,
//     this.width = 200,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.pushNamed(context, NoteDetaiScreen.routeName);
//       },
//       child: 
//       Container(
//         // margin: EdgeInsets.symmetric(horizontal: 10),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           border: Border.all(width: 2, color: Colors.black),
//           borderRadius: BorderRadius.circular(20),
//           color: color,
//         ),
//         width: 180,
//         height: 245,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "It's not going anywhere man",
//               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                   fontSize: 17,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w900),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 5),
//               child: Text('8th Aug 2023',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium!
//                       .copyWith(fontSize: 13, color: Colors.grey.shade700)),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 7),
//               child: Text(
//                   "Don't read the caption ,it's all same ,you dumb dumb ,did you even read this.",
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium!
//                       .copyWith(color: Colors.grey.shade600, fontSize: 15)),
//             ),
            
//             Positioned(
//               left: 0,
//               bottom: 0,
//               child: FlutterLogo(
//                 textColor: Colors.pink,
//                 style: FlutterLogoStyle.markOnly,
//                 size: 25,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
