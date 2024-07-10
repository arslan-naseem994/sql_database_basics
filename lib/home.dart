import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_practice/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _dbs = DBHelper();
  // String emails = '';
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call initDatabase here to ensure it's initialized before using it
    _initializeDatabase();
    loadData();
  }

  // Function to initialize the database
  void _initializeDatabase() async {
    await _dbs.db; // Call db property to initialize the database
  }

  void loadData() async {
    List<Map<String, dynamic>> lists = await _dbs.getemail();
    if (lists.isNotEmpty) {
      emailController.text = lists[0]['email'];
      setState(() {});
    } else {
      emailController.text = 'noValue';
    }

    // SharedPreferences sd = await SharedPreferences.getInstance();
    // emails = sd.getString('email').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
        actions: [
          GestureDetector(
              onTap: () {
                _dbs.delete(emailController.text);
                emailController.text = '';
              },
              child: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // emails.isEmpty ? const Text('igi') : Text(emails.toString()),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 50,
            ),
            GestureDetector(
              onTap: () async {
                final DBHelper dbs = DBHelper();

                // SharedPreferences sd = await SharedPreferences.getInstance();
                // sd.setString('email', emailController.text.toString());
                // emails = sd.getString('email').toString();
                // Call insert method to add email to the database
                await dbs.insert('emaslanz@gmail.com');

                // Call getemail method to retrieve emails from the database
                List<Map<String, dynamic>> lists = await dbs.getemail();
                if (lists.isNotEmpty) {
                  emailController.text = lists[0]['email'];
                  setState(() {});
                } else {
                  // Handle the case when the list is empty
                }
              },
              child: const RoundButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  const RoundButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.deepOrange,
      ),
      child: const Center(
        child: Text('Button'),
      ),
    );
  }
}
