
import 'package:flutter/material.dart';
import 'package:sql_lite/Data/Local/db_helper.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  /// Controllers
  TextEditingController titleController=TextEditingController();
  TextEditingController descController=TextEditingController();

  /// all notes
  List<Map<String,dynamic>> allNotes=[];
  DbHelper? dbRef;

  @override
  void initState() {


    super.initState();
    dbRef=DbHelper.getinstance;
    getNotes();
  }
  getNotes()async{

    allNotes= await dbRef!.getAllNote();
    setState(() {

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task Notes"),
      ),
      body: allNotes.isEmpty ? Center(child: Text("No Task Yet")) : ListView.builder(itemCount: allNotes.length,
          itemBuilder: (_,index){
        return ListTile(
          leading: Text(allNotes[index][DbHelper.COLUMN_SNO].toString()),
          title: Text(allNotes[index][DbHelper.COLUMN_TITLE]),
          subtitle: Text(allNotes[index][DbHelper.COLUMN_DESC]),
        );
        


    },

      ),

      floatingActionButton:FloatingActionButton(onPressed: (){
        showModalBottomSheet( isScrollControlled: true,
            context: context, builder: (context){
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              height: 500,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child:SingleChildScrollView(
                child: Column(


                  children: [
                    Text("Add Notes",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                    SizedBox(height: 10,),
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
                        labelText: "Title"
                      ),
                    ),
                    SizedBox(height: 10,),
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
                          labelText: "Description"
                      ),
                      ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(onPressed: (){
                            dbRef!.addNote(mTitle: titleController.text, mDesc: descController.text.trim());
                            getNotes();
                            Navigator.pop(context);


                          }, child: Text("Add Notes")),
                        ),
                        Expanded(
                          child: OutlinedButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("Cancel")),
                        ),
                      ],
                    )



                  ],
                ),

              ),

            ),
          );

        });

      },
        child:Icon(Icons.add),),
      
      

    );

  }
}
