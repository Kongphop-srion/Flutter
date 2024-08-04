import 'package:flutter/material.dart';
import 'package:kpbmi/shopping.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String? _sex;
  var _age;
  var _weight;
  var _height;

  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ageController.addListener(_updateText);
    _weightController.addListener(_updateText);
    _heightController.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _age = _ageController.text;
      _weight = _weightController.text;
      _height = _heightController.text;
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI CHECKER')),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("Sex"),
                Radio(
                  value: "Male",
                  groupValue: _sex,
                  onChanged: (value) {
                    setState(() {
                      _sex = value as String?;
                    });
                  },
                ),
                Text("Male"),
                Radio(
                  value: "Female",
                  groupValue: _sex,
                  onChanged: (value) {
                    setState(() {
                      _sex = value as String?;
                    });
                  },
                ),
                Text("Female"),
              ],
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: "Age",
                icon: Icon(Icons.assignment_ind_sharp),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: "Weight (kg)", // Updated label to include unit
                icon: Icon(Icons.electric_meter),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _heightController,
              decoration: InputDecoration(
                labelText: "Height (cm)", // Updated label to include unit
                icon: Icon(Icons.accessibility_new_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            MyBtn(context)
          ],
        ),
      ),
    );
  }

  Center MyBtn(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Check BMI   ",
              style: TextStyle(fontSize: 15),
            ),
            Icon(Icons.arrow_circle_right),
          ],
        ),
        onPressed: () {
          if (_sex != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return formshopping(
                    Sex: _sex!,
                    Age: _ageController.text,
                    Weight: _weightController.text,
                    Height: _heightController.text,
                  );
                },
              ),
            );
          } else {
            // Handle the case where Sex is not selected
            // Show an error message or provide feedback to the user
          }
        },
      ),
    );
  }
}
