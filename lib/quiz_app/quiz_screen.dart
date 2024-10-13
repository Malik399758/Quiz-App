import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urraan_quiz_app/quiz_app/quiz_helper.dart';
import 'package:urraan_quiz_app/quiz_app/quiz_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuizHelper quizHelper = QuizHelper();
  List<QuizModel> list = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;
  int score = 0; // Score variable
  int? selectedAnswer; // To track the selected answer

  @override
  void initState() {
    super.initState();
    _insertAndFetchData();
  }

  // Insert sample questions and fetch them afterward
  void _insertAndFetchData() async {
    list = await quizHelper.fetchRecord();
    if(list.isEmpty){
      await _insertSimpleQuestion(); // First, insert the sample questions
    }

    _fetchRecord(); // Then, fetch the questions after insertion
  }

  // Insert initial sample questions into the database
  Future<void> _insertSimpleQuestion() async {
    try {
      await quizHelper.insertSimpleQuestion(); // Insert sample questions
      print('Inserted initial questions');
    } catch (e) {
      print('Error inserting questions: ${e.toString()}');
    }
  }

  // Fetch the quiz data from the database
  void _fetchRecord() async {
    try {
      final data = await quizHelper.fetchRecord();
      print('Data Fetch $data');
      setState(() {
        list = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error Fetching data ${e.toString()}');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to move to the next question
  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < list.length - 1) {
        currentQuestionIndex++;
        selectedAnswer = null; // Reset answer selection for the next question
      } else {
        _showCompletionDialog();
      }
    });
  }

  // Show quiz completion dialog
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Complete'),
        content: Text('You scored: $score/${list.length}'), // Show the score
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentQuestionIndex = 0;
                score = 0; // Reset score for the next quiz
              });
            },
            child: Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }

  // Function to check the answer
  void _checkAnswer(int selectedOption) {
    setState(() {
      selectedAnswer = selectedOption; // Store the selected answer
      // Check if the selected option is correct
      if (selectedOption == list[currentQuestionIndex].correctAnswer) {
        score++; // Increment score for correct answer
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : list.isEmpty
          ? Center(child: Text('No data available'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${list.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              list[currentQuestionIndex].question,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            _buildOptionButton(list[currentQuestionIndex].option1, 1),
            _buildOptionButton(list[currentQuestionIndex].option2, 2),
            _buildOptionButton(list[currentQuestionIndex].option3, 3),
            _buildOptionButton(list[currentQuestionIndex].option4, 4),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: selectedAnswer != null ? _nextQuestion : null, // Disable until an answer is selected
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build option buttons
  Widget _buildOptionButton(String optionText, int optionNumber) {
    bool isSelected = selectedAnswer == optionNumber; // Check if this option is selected
    bool isCorrectAnswer = optionNumber == list[currentQuestionIndex].correctAnswer; // Check if the option is correct
    Color? backgroundColor;

    // Determine the background color based on the selection and correctness
    if (isSelected) {
      if (isCorrectAnswer) {
        backgroundColor = Colors.green[300]!; // Correct answer selected
      } else {
        backgroundColor = Colors.red[300]!; // Incorrect answer selected
      }
    } else {
      backgroundColor = null; // Default background color
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          _checkAnswer(optionNumber); // Check answer when pressed
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              optionText,
              style: TextStyle(fontSize: 18),
            ),
            if (isSelected) ...[
              SizedBox(width: 10),
              Icon(
                isCorrectAnswer ? Icons.check : Icons.close,
                color: isCorrectAnswer ? Colors.green : Colors.red,
              ),
            ],
          ],
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: backgroundColor, // Set the determined background color
        ),
      ),
    );
  }
}
