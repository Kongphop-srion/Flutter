import 'package:flutter/material.dart';

class formshopping extends StatelessWidget {
  formshopping({
    Key? key,
    required this.Sex,
    required this.Age,
    required this.Weight,
    required this.Height,
  }) : super(key: key);

  final String Sex, Age, Weight, Height;

  double calculateTargetWeight() {
    double targetBMI = 22.9;
    double currentBMI = calculateBMI();

    if (currentBMI < targetBMI) {
      double currentWeight = double.parse(Weight);
      double currentHeight =
          double.parse(Height) / 100.0; // Convert Height to meters

      double targetWeight = targetBMI * (currentHeight * currentHeight);
      return targetWeight - currentWeight;
    } else if (currentBMI > targetBMI) {
      double currentWeight = double.parse(Weight);
      double currentHeight =
          double.parse(Height) / 100.0; // Convert Height to meters

      double targetWeight = targetBMI * (currentHeight * currentHeight);
      return currentWeight - targetWeight;
    } else {
      return 0.0;
    }
  }

  double calculateBMI() {
    double weight = double.parse(Weight);
    double height = double.parse(Height) / 100.0; // Convert Height to meters
    return weight / (height * height);
  }

  double calculateBMR() {
    double weight = double.parse(Weight);
    double height = double.parse(Height);
    int age = int.parse(Age);

    return (Sex.toLowerCase() == 'male')
        ? 66 + (13.7 * weight) + (5 * height) - (6.8 * age)
        : 665 + (9.6 * weight) + (1.8 * height) - (4.7 * age);
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi <= 22.9) {
      return 'Normal weight';
    } else if (bmi >= 23.0 && bmi <= 24.9) {
      return 'Risk to overweight';
    } else if (bmi >= 25.0 && bmi <= 29.9) {
      return 'Overweight';
    } else if (bmi >= 30.0) {
      return 'Obesity';
    } else {
      return 'Unknown category';
    }
  }

  String getImageAssetPath(String bmiCategory) {
    switch (bmiCategory) {
      case 'Underweight':
        return 'assets/images/bmi-1.png';
      case 'Normal weight':
        return 'assets/images/bmi-2.png';
      case 'Risk to overweight':
        return 'assets/images/bmi-3.png';
      case 'Overweight':
        return 'assets/images/bmi-4.png';
      case 'Obesity':
        return 'assets/images/bmi-5.png';
      default:
        return 'assets/unknown_image.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    double targetWeight = calculateTargetWeight();
    double bmi = calculateBMI();
    double bmr = calculateBMR();
    String bmiCategory = getBMICategory(bmi);
    String imageAssetPath = getImageAssetPath(bmiCategory);

    String weightChangeMessage = '';

    if (targetWeight > 0.0) {
      weightChangeMessage =
          'To reach normal weight, you need to gain ${targetWeight.toStringAsFixed(2)} kg.';
    } else if (targetWeight < 0.0) {
      weightChangeMessage =
          'To reach normal weight, you need to lose ${(-targetWeight).toStringAsFixed(2)} kg.';
    } else {
      weightChangeMessage = 'You are already in the normal weight range.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Sex),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Sex: $Sex\nAge: $Age',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'BMI: ${bmi.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'BMI Category: $bmiCategory',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20.0),
            Image.asset(
              imageAssetPath,
              width: 350,
              height: 350,
            ),
            SizedBox(height: 20.0),
            Text(
              'BMR: ${bmr.toStringAsFixed(2)} kcal/day',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20.0),
            Text(
              weightChangeMessage,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
