import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:learn_sqflight/data/local_db/local_db.dart';
import 'package:learn_sqflight/note_detail_screen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocalDb? localDb;
  List<Map<String, dynamic>> noteList = [];
  bool isUpdate = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  @override
  void initState() {
    super.initState();
    localDb = LocalDb.localDb;
    getAllNote();
  }

  Future<void> getAllNote() async {
    noteList = await localDb!.getAllNote();
    isUpdate = false;
    titleController.clear();
    descController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        backgroundColor: Color(0xff155DFC),
        elevation: 5,
        title: Text("Notes", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: AnimatedSlide(
        offset: const Offset(0, 0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 300),
          child: listCard(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff155DFC),
        elevation: 6,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "New Note",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onPressed: () {
          showNoteBottomSheet(context);
        },
      ),
    );
  }

  Widget listCard() {
    return noteList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  size: 90,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  "No Notes Yet",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    children: const [
                      TextSpan(text: "Tap "),
                      TextSpan(
                        text: "+",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(text: " to create your first note"),
                    ],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: noteList.length,
            itemBuilder: (context, index) {
              final note = noteList[index];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(
                        title: note[LocalDb.titleColumn],
                        description: note[LocalDb.descColumn],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: index == 0 ? 20 : 0,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Color(0xff155DFC),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note[LocalDb.titleColumn],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                note[LocalDb.descColumn],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    formatDate(note[LocalDb.createdByColumn]),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                height: 1,
                                color: Colors.grey.shade100,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      isUpdate = true;
                                      showNoteBottomSheet(
                                        context,
                                        note[LocalDb.idColumn],
                                        note[LocalDb.titleColumn],
                                        note[LocalDb.descColumn],
                                      );
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "Update",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      localDb!
                                          .deleteNote(
                                            id: note[LocalDb.idColumn],
                                          )
                                          .then((value) {
                                            if (value > 0) {
                                              getAllNote();
                                              IconSnackBar.show(
                                                context,
                                                snackBarType:
                                                    SnackBarType.success,
                                                label:
                                                    'Note deleted successfully',
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              );
                                            }
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.delete,
                                            size: 18,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
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
                ),
              );
            },
          );
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat("d MMM, yyyy, hh:mm a").format(parsedDate);
  }

  void showNoteBottomSheet(
    BuildContext pContext, [
    int? id,
    String? title,
    String? desc,
  ]) {
    if (isUpdate) {
      titleController.text = title!;
      descController.text = desc!;
    }

    showModalBottomSheet(
      context: pContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        isUpdate = false;
                        setState(() {});
                        titleController.clear();
                        descController.clear();
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16,
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          Visibility(
                            visible: isUpdate,
                            child: Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (titleController.text.trim().isEmpty ||
                                      descController.text.trim().isEmpty) {
                                    showTopSnackBar(
                                      displayDuration: Duration(seconds: 1),
                                      Overlay.of(pContext),
                                      const CustomSnackBar.error(
                                        message: "All fields required",
                                      ),
                                    );
                                  } else {
                                    localDb!
                                        .updateNote(
                                          row: {
                                            LocalDb.titleColumn:
                                                titleController.text,
                                            LocalDb.descColumn:
                                                descController.text,
                                            LocalDb.createdByColumn:
                                                DateTime.now().toString(),
                                          },
                                          id: id!,
                                        )
                                        .then((value) {
                                          if (value > 0) {
                                            Navigator.pop(context);
                                            getAllNote();
                                            IconSnackBar.show(
                                              context,
                                              snackBarType:
                                                  SnackBarType.success,
                                              label: 'Note Update successfully',
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            );
                                          }
                                        });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff155DFC),
                                ),
                                child: const Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: !isUpdate,
                            child: Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff155DFC),
                                ),
                                onPressed: () {
                                  if (titleController.text.trim().isEmpty ||
                                      descController.text.trim().isEmpty) {
                                    showTopSnackBar(
                                      displayDuration: Duration(seconds: 1),
                                      Overlay.of(pContext),
                                      const CustomSnackBar.error(
                                        message: "All fields required",
                                      ),
                                    );
                                  } else {
                                    localDb!
                                        .insertNote(
                                          rows: {
                                            LocalDb.titleColumn:
                                                titleController.text,
                                            LocalDb.descColumn:
                                                descController.text,
                                            LocalDb.createdByColumn:
                                                DateTime.now().toString(),
                                          },
                                        )
                                        .then((value) {
                                          if (value > 0) {
                                            Navigator.pop(context);
                                            getAllNote();
                                            IconSnackBar.show(
                                              context,
                                              snackBarType:
                                                  SnackBarType.success,
                                              label: 'Note Add successfully',
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            );
                                          }
                                        });
                                  }
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
