import 'package:flutter/material.dart';
import 'package:sql_lite/Data/Local/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  /// all notes
  List<Map<String, dynamic>> allNotes = [];
  DbHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DbHelper.getinstance;
    getNotes();
  }

  getNotes() async {
    allNotes = await dbRef!.getAllNote();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Task Notes")),
      body: allNotes.isEmpty
          ? Center(child: Text("No Task Yet"))
          : ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  margin: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    leading: Text("${index + 1}"),
                    title: Text(allNotes[index][DbHelper.COLUMN_TITLE]),
                    subtitle: Text(allNotes[index][DbHelper.COLUMN_DESC]),
                    trailing: SizedBox(
                      width: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  titleController.text =
                                      allNotes[index][DbHelper.COLUMN_TITLE];
                                  descController.text =
                                      allNotes[index][DbHelper.COLUMN_DESC];

                                  return getBottomSheet(
                                    isUpdate: true,
                                    sno: allNotes[index][DbHelper.COLUMN_SNO],
                                  );
                                },
                              );
                            },

                            child: Icon(Icons.edit, size: 20),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () async {
                              bool delete = await dbRef!.deleteNote(
                                sno: allNotes[index][DbHelper.COLUMN_SNO],
                              );
                              getNotes();
                            },

                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return getBottomSheet();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheet({isUpdate = false, int sno = 0}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,

        padding: EdgeInsets.only(
          bottom: MediaQuery.of(
            context,
          ).viewInsets.bottom, // keyboard ke upar adjust
          left: 10,
          right: 10,
          top: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                isUpdate ? "Update Note" : "Add Notes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter title",
                  labelText: "Title",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: 4,
                controller: descController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter description",
                  labelText: "Description",
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        var title = titleController.text;
                        var desc = descController.text.trim();
                        if (title.isNotEmpty || desc.isNotEmpty) {
                          bool cheack = await (isUpdate
                              ? dbRef!.updateNote(
                                  mTitle: title,
                                  mDesc: desc,
                                  sno: sno,
                                )
                              : dbRef!.addNote(mTitle: title, mDesc: desc));
                        }
                        titleController.clear();
                        descController.clear();
                        getNotes();
                        Navigator.pop(context);
                      },
                      child: Text(isUpdate ? "Update" : "Add Notes"),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
