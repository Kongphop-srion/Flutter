// main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'sql_helper.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PROFILE DATA',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late List<Map<String, dynamic>> _people;
  bool _isLoading = true;

  void _refreshPeople() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _people = data.map((person) {
        final birthDate = DateTime.parse(person['birthdate']);
        final age = DateTime.now().year - birthDate.year;
        return {...person, 'age': age};
      }).toList();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshPeople();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _gender = 'Male'; // Default gender

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _ageController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 600,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingPerson =
          _people.firstWhere((element) => element['id'] == id);
      _nameController.text = existingPerson['title'];
      _weightController.text = existingPerson['weight'].toString();
      _heightController.text = existingPerson['height'].toString();
      _selectedDate = DateTime.parse(existingPerson['birthdate']);
      _ageController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      _gender = existingPerson['gender'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text('Take a picture'),
                          onTap: () {
                            _getImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Choose from gallery'),
                          onTap: () {
                            _getImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text('Select Image'),
            ),
            _image != null
                ? Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : Container(),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(hintText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(hintText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _ageController,
              decoration:
                  const InputDecoration(hintText: 'Birthdate (yyyy-MM-dd)'),
              keyboardType: TextInputType.datetime,
              onTap: () {
                _selectDate(context);
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Gender: '),
                DropdownButton<String>(
                  value: _gender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty ||
                    _weightController.text.isEmpty ||
                    _heightController.text.isEmpty ||
                    _ageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill in all fields.'),
                  ));
                } else {
                  try {
                    double.parse(_weightController.text);
                    double.parse(_heightController.text);
                    DateFormat('yyyy-MM-dd').parse(_ageController.text);

                    if (id == null) {
                      await _addPerson();
                    } else {
                      await _updatePerson(id);
                    }

                    _nameController.text = '';
                    _weightController.text = '';
                    _heightController.text = '';
                    _ageController.text = '';

                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Please enter valid numeric values for weight and height, and valid date in yyyy-MM-dd format for birthdate.',
                      ),
                    ));
                  }
                }
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPerson() async {
    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text) / 100.0;
    final birthDate = _ageController.text;

    String imagePath = '';
    if (_image != null) {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final String savedImagePath = '$appDocPath/$fileName';
      await _image!.copy(savedImagePath);
      imagePath = savedImagePath;
    }

    await SQLHelper.createItemWithImage(
      _nameController.text,
      null,
      weight,
      height,
      _gender,
      birthDate,
      imagePath,
    );
    _refreshPeople();
  }

  Future<void> _updatePerson(int id) async {
    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text) / 100.0;
    final birthDate = _ageController.text;

    await SQLHelper.updateItem(
      id,
      _nameController.text,
      null,
      weight,
      height,
      _gender,
      birthDate,
    );
    _refreshPeople();
  }

  void _deletePerson(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a person!'),
    ));
    _refreshPeople();
  }

  double _calculateBMI(double weight, double height) {
    return weight / pow(height, 2);
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal Weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Data'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _people.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    backgroundImage: _people[index]['imagePath'] != ''
                        ? FileImage(File(_people[index]['imagePath']))
                        : null,
                    child: _people[index]['imagePath'] == '' ||
                            _people[index]['imagePath'] == null
                        ? Icon(Icons.person)
                        : null,
                  ),
                  title: Text(_people[index]['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight: ${_people[index]['weight']} kg\n'
                        'Height: ${_people[index]['height']} cm\n'
                        'Age: ${_people[index]['age']} years\n'
                        'Gender: ${_people[index]['gender']}',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'BMI: ${_calculateBMI(_people[index]['weight'], _people[index]['height'])}\n'
                        'Status: ${_getBMIStatus(_calculateBMI(_people[index]['weight'], _people[index]['height']))}',
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showForm(_people[index]['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deletePerson(_people[index]['id']),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
