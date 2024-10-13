class QuizModel{
  int? id;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  int correctAnswer;

  // Constructor;

 QuizModel({
    this.id,
   required this.question,
   required this.option1,
   required this.option2,
   required this.option3,
   required this.option4,
   required this.correctAnswer,
});

 // Convert object into Map
 Map<String,dynamic> toMap(){
   return {
     'id':id,
     'question':question,
     'option1':option1,
     'option2':option2,
     'option3':option3,
     'option4':option4,
     'correctAnswer':correctAnswer
   };
 }

 factory QuizModel.fromMap(Map<String,dynamic> map){
   return QuizModel(
       id:map['id'],
       question: map['question'],
       option1: map['option1'],
       option2:map['option2'],
       option3: map['option3'],
       option4: map['option4'],
       correctAnswer: map['correctAnswer']
   );
 }


}