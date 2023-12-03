import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:notes_app_ui/screens/select_category_screen.dart';

class WriteNoteScreen extends StatefulWidget {
  static const routeName = '/write_note_screen';
  const WriteNoteScreen({super.key});

  @override
  State<WriteNoteScreen> createState() => _WriteNoteScreenState();
}

class _WriteNoteScreenState extends State<WriteNoteScreen> {
  QuillController _controller = QuillController.basic();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  int newLinesCount = 0;
  // ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String categoryName = 'Uncategorized';
  QueryDocumentSnapshot<Map<String, dynamic>>? categoryDoc;
  bool isInitState = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isInitState = true;
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   isInitState = true;
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    titleController.dispose();
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isInputEnabled = true;
    if (isInitState) {
      print('HELOOOOOOOOOOO /////////////////////////////////////');
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (arguments != null) {
        titleController.text = arguments['title'];
        _controller.document = Document.fromJson(arguments['content']);
        categoryName = arguments['category'];
      }
      isInitState = false;
    }

    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 27,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            // const CircleAvatar(
            //   backgroundImage: NetworkImage(
            //       'https://i.pinimg.com/236x/d5/fc/5c/d5fc5cd3f13aac0361a4f2479edc1379.jpg'),
            // ),
            Text('  Mounir', style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
        actions: [
          InkWell(
              onTap: createNote,
              child: Row(
                children: [
                  Text(
                    'Confirm',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Icon(CupertinoIcons.arrow_down_doc_fill,
                      color: Colors.black)
                ],
              ))
        ],
      ),

      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height * 0.91),
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.83,
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.only(top: 20.0, bottom: 60),
            margin: const EdgeInsets.only(bottom: 80, left: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    final category = await Navigator.of(context).pushNamed(
                            SelectCategoryScreen.routeName,
                            arguments: {'categoryName': categoryName})
                        as Map<String, dynamic>;

                    setState(() {
                      categoryName = category['categoryName']['name'];
                      print(categoryName);
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: const EdgeInsets.only(left: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey, width: 3)),
                    child: Text(
                      categoryName,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey, letterSpacing: 1.5, fontSize: 13),
                    ),
                  ),
                ),

                Form(
                  child: Column(children: [
                    TextFormField(
                      enabled: isInputEnabled,
                      onChanged: (value) {
                        if (value.length > 50) {
                          titleController.text = value.substring(0, 50);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(milliseconds: 50),
                                  content: Text('Title length exceeded')));
                        }
                      },
                      maxLines: 2,
                      style: const TextStyle(fontSize: 25),
                      controller: titleController,
                      decoration: const InputDecoration(
                          focusColor: Colors.black,
                          filled: true,
                          fillColor: Colors.transparent,
                          // label: Text('Title', style: TextStyle(fontSize: 25),) ,
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                    QuillEditor(
                      // scrollBottomInset: 20,

                      scrollController: ScrollController(),
                      controller: _controller,
                      scrollable: false,
                      autoFocus: false,
                      padding: const EdgeInsets.all(10),
                      focusNode: FocusNode(),
                      readOnly: false,
                      expands: false,
                      placeholder: 'Notes',
                      // padding: EdgeInsets.all(6),
                      // placeholder: 'Notes',
                      // controller: _controller, readOnly: false
                    )
                    // TextFormField(
                    //   style: TextStyle(fontSize: 25),
                    //   controller: notesController,
                    //   decoration: const InputDecoration(
                    //     focusColor: Colors.black,
                    //     filled: true ,
                    //     fillColor: Colors.transparent ,
                    //     // label: Text('Title', style: TextStyle(fontSize: 25),) ,
                    //     hintText: 'Notes',
                    //     hintStyle: TextStyle(fontSize: 25),
                    //     border: InputBorder.none
                    //   ),
                    // )
                  ]),
                ),
                // QuillEditor.basic(controller: _controller,readOnly: false, ),
                // const Spacer(),
              ],
            ),
          ),
        ),
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.all(5),
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black, width: 0.5))),
        child: QuillToolbar.basic(
          toolbarIconSize: 25,
          controller: _controller,
          showAlignmentButtons: false,
          multiRowsDisplay: true,
          showDividers: false,
          showFontFamily: false,
          showFontSize: true,
          showBoldButton: false,
          showItalicButton: false,
          showSmallButton: false,
          showUnderLineButton: true,
          showStrikeThrough: false,
          showInlineCode: false,
          showColorButton: false,
          showBackgroundColorButton: false,
          showClearFormat: false,
          showLeftAlignment: true,
          showCenterAlignment: true,
          showRightAlignment: true,
          showJustifyAlignment: true,
          showHeaderStyle: false,
          showListNumbers: true,
          showListBullets: true,
          showListCheck: true,
          showCodeBlock: false,
          showQuote: false,
          showIndent: true,
          showLink: false,
          showUndo: false,
          showRedo: false,
          showDirection: false,
          showSearchButton: false,
          showSubscript: false,
          showSuperscript: false,
        ),
      ),
    );
  }

  void createNote() async {
    print("CREATE NOTE FUNCTIOOOON ///////////////////////////////");
    final title = titleController.text;
    final note = _controller.document;
    final category = categoryName;
    final categoryId;
    try {
      if (category == 'Uncategorized') {
        categoryId = await getOrCreateCategoryId(category);
        if (titleController.text.isEmpty && _controller.document.isEmpty()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Note is empty')));
        } else if (_controller.document.isEmpty()) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You have to write some notes')));
        } else if (titleController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You have to add a title')));
        }
        await addNoteToFirestore(title, note, category, categoryId);

        // Clear Quill editor content
      } else {
        final categoryDoc = await FirebaseFirestore.instance
            .collection('categories')
            .where('name', isEqualTo: categoryName)
            .get();
        categoryId = categoryDoc.docs[0].id;
        addNoteToFirestore(title, note, category, categoryId);
      }
      titleController.clear();
      _controller.document = Document();
      Navigator.of(context).pop();
    } catch (error) {
      print('Error creating note: $error');
      // Handle the error here, e.g., show a snackbar, display an error message to the user, etc.
    }
  }

  Future<void> addNoteToFirestore(
      String title, Document note, String category, String categoryId) async {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    try {
      if (arguments != null) {
        await FirebaseFirestore.instance
            .collection('notes')
            .doc(arguments['noteId'])
            .set({
          'category': category,
          'categoryId': categoryId,
          'content': note.toDelta().toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'title': title,
          'userID': FirebaseAuth.instance.currentUser!.uid,
        });
      } else {
        await FirebaseFirestore.instance.collection('notes').add({
          'category': category,
          'categoryId': categoryId,
          'content': note.toDelta().toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'title': title,
          'userID': FirebaseAuth.instance.currentUser!.uid,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("something went wrong")));
    }
  }

  Future<String> getOrCreateCategoryId(String category) async {
    final categoryQuery = await FirebaseFirestore.instance
        .collection('categories')
        .where('name', isEqualTo: category)
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (categoryQuery.size > 0) {
      
      return categoryQuery.docs.first.id;
    } else {
      final createdCategory =
          await FirebaseFirestore.instance.collection('categories').add({
        'name': category,
        'userID': FirebaseAuth.instance.currentUser!.uid,
      });

      final categoryDoc = await createdCategory.get();
      final categoryName = categoryDoc.data()!['name'];

      return categoryName;
    }
  }
}
