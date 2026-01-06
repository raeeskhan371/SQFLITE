import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {

   DbHelper._();
   static final DbHelper getinstance=DbHelper._();
   ///table note
   static final String TABLE_NOTE="note";
   static final String COLUMN_SNO="s_no";
   static final String COLUMN_TITLE="title";
   static final String COLUMN_DESC="desc";






   /// ( Create global Variable)
   Database? mydb;

   /// ( path if -> exist  then open else create db)
  Future<Database> getDB()async{
    if(mydb!=null){
      return mydb!;
    }else {
      mydb=await openDB();
      return mydb!;

    }
  }

  Future<Database> openDB()async{
    Directory appDir= await getApplicationDocumentsDirectory();
    String dbpath=join(appDir.path,"note.db");
    return await openDatabase(dbpath,onCreate: (db,version){


      /// creat all your table here
      db.execute("create table $TABLE_NOTE($COLUMN_SNO INTEGER PRIMARY KEY AUTOINCREMENT,$COLUMN_TITLE TEXT,$COLUMN_DESC TEXT) ");


    },version: 1);
    
  }


  ///  all queries
 /// insert data in table

   Future<bool>addNote({required String mTitle, required String mDesc})async{
    var db=await getDB();
    int rowsEffected=await db.insert(TABLE_NOTE,{
      COLUMN_TITLE:mTitle,
      COLUMN_DESC:mDesc,

    });
    return rowsEffected>0;
   }

   Future<List<Map<String,dynamic>>> getAllNote()async{
    var db=await getDB();
    List<Map<String,dynamic>> mData= await db.query(TABLE_NOTE);
    return mData;
   }




}