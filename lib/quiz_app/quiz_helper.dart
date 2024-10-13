import 'package:path/path.dart'as p;
import 'package:sqflite/sqflite.dart';
import 'package:urraan_quiz_app/quiz_app/quiz_model.dart';


// Global Variable
String tableName = 'QuizTable';
String id = 'id';
String question = 'question';
String option1 = 'option1';
String option2 = 'option2';
String option3 = 'option3';
String option4 = 'option4';
String correctAnswer = 'correctAnswer';

class QuizHelper{
  //Private
  QuizHelper._();

  static QuizHelper? quizHelper;

  factory QuizHelper(){
    if(quizHelper == null){
      quizHelper = QuizHelper._();
    }
    return quizHelper!;
  }

  // Singleton pattern for Database
 Database? _database;

  /// if exists then open else create database

  Future<Database>get database async{
    if(_database == null){
      _database = await CreateDb();
    }
    return _database!;
  }

  // Create Database here
  Future<Database> CreateDb() async{
    var openDb;
    try{
      String CreateTable = '''
      create table $tableName (
      $id integer primary key autoincrement,
      $question text,
      $option1 text,
      $option2 text,
      $option3 text,
      $option4 text,
      $correctAnswer integer
      
      
      )
      
      ''';
      String appDir = await getDatabasesPath();
      String openPath = p.join(appDir,'QuizDatabase.db');

      // open Database file
     openDb = await openDatabase(openPath,version: 1,onCreate: (Database db,int version){
        // Create a table here
        db.execute(CreateTable);
        print('Table Created $openDb');
      });
    } catch(e){
      print('Table Creation error${e.toString()}');
    }
    return openDb;
  }

  // Insertion

 Future<bool> insertRecord(QuizModel quizModel) async{
    try{
      Database db = await database;
     var count = await db.insert(tableName, quizModel.toMap());
     print('Data Inserted $count');
     return true;
    } catch(e){
      print('Data insert error ${e.toString()}');
      return false;
    }
 }

 // Fetch
 Future<List<QuizModel>>fetchRecord() async{
    List<QuizModel> list = [];
    try{
      Database db = await database;
      final List<Map<String,dynamic>> listMap = await db.query(tableName);
      if(listMap.isNotEmpty){
        listMap.forEach((Map<String,dynamic> action){
          QuizModel quizModel = QuizModel.fromMap(action);
          list.add(quizModel);


        });
      }
      print('Fetch Data Successfully');
      return list;
    } catch (e){
      print('Fetching data error ${e.toString()}');
      return list;
    }
 }

 // Some question

  Future<void> insertSimpleQuestion() async {
    await insertRecord(QuizModel(
      question: 'What is the capital of France?',
      option1: 'Berlin',
      option2: 'Madrid',
      option3: 'Paris',
      option4: 'Lisbon',
      correctAnswer: 3,
    ));

    await insertRecord(QuizModel(
      question: 'Who wrote "Romeo and Juliet"?',
      option1: 'William Shakespeare',
      option2: 'Charles Dickens',
      option3: 'J.K. Rowling',
      option4: 'Mark Twain',
      correctAnswer: 1,
    ));

    await insertRecord(QuizModel(
      question: 'What is the largest planet in our solar system?',
      option1: 'Earth',
      option2: 'Jupiter',
      option3: 'Mars',
      option4: 'Saturn',
      correctAnswer: 2,
    ));

    await insertRecord(QuizModel(
      question: 'What year did World War I begin?',
      option1: '1914',
      option2: '1939',
      option3: '1918',
      option4: '1923',
      correctAnswer: 1,
    ));

    await insertRecord(QuizModel(
      question: 'What element does "O" represent on the periodic table?',
      option1: 'Oxygen',
      option2: 'Osmium',
      option3: 'Gold',
      option4: 'Oganesson',
      correctAnswer: 1,
    ));

    await insertRecord(QuizModel(
      question: 'Who painted the Mona Lisa?',
      option1: 'Vincent van Gogh',
      option2: 'Leonardo da Vinci',
      option3: 'Pablo Picasso',
      option4: 'Claude Monet',
      correctAnswer: 2,
    ));

    await insertRecord(QuizModel(
      question: 'What is the capital of Japan?',
      option1: 'Beijing',
      option2: 'Seoul',
      option3: 'Tokyo',
      option4: 'Bangkok',
      correctAnswer: 3,
    ));

    await insertRecord(QuizModel(
      question: 'Which planet is known as the Red Planet?',
      option1: 'Earth',
      option2: 'Mars',
      option3: 'Venus',
      option4: 'Mercury',
      correctAnswer: 2,
    ));

    await insertRecord(QuizModel(
      question: 'In which year did the Titanic sink?',
      option1: '1912',
      option2: '1905',
      option3: '1920',
      option4: '1915',
      correctAnswer: 1,
    ));

    await insertRecord(QuizModel(
      question: 'Who developed the theory of relativity?',
      option1: 'Isaac Newton',
      option2: 'Albert Einstein',
      option3: 'Galileo Galilei',
      option4: 'Nikola Tesla',
      correctAnswer: 2,
    ));
  }






} // End of Class