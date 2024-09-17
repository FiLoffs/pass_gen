import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

void main() {
  runApp(const PasswordGeneratorApp());
}

class PasswordGeneratorApp extends StatelessWidget {
  const PasswordGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Генератор паролів',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue, // Neutral lightBlue color scheme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PasswordGeneratorScreen(),
    );
  }
}

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  PasswordGeneratorScreenState createState() =>
      PasswordGeneratorScreenState();
}

class PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  String _password = ''; // To store the generated password
  double _passwordLength = 6; // Default password length
  bool _includeUppercase = true; // Enable/disable uppercase letters
  bool _includeLowercase = true; // Enable/disable lowercase letters
  bool _includeNumbers = true; // Enable/disable numbers
  bool _includeSpecialCharacters = true; // Enable/disable special characters

  final _upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final _lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  final _numbers = '0123456789';
  final _specialCharacters = '!@#\$%^&*()_+{}[]|:;<>,.?';

  void _generatePassword() {
    String chars = ''; // String to hold characters for password generation

    if (_includeUppercase) {
      chars += _upperCaseLetters; // Add uppercase letters if enabled
    }
    if (_includeLowercase) {
      chars += _lowerCaseLetters; // Add lowercase letters if enabled
    }
    if (_includeNumbers) chars += _numbers; // Add numbers if enabled
    if (_includeSpecialCharacters) {
      chars += _specialCharacters; // Add special characters if enabled
    }

    if (chars.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Необхідно зробити вибір!')),
      );
      return;
    }

    setState(() {
      _password = List.generate(_passwordLength.toInt(),
              (index) => chars[Random().nextInt(chars.length)])
          .join(); // Generate a random password from selected characters
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Neutral white background
      appBar: AppBar(
        title: const Text('Генератор паролів'),
        backgroundColor: Colors.lightBlue[200], // lightBlue app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGeneratedPasswordText(),
              const SizedBox(height: 20),
              _buildPasswordLengthSlider(),
              const SizedBox(height: 20),
              _buildOptionsCheckboxes(),
              const SizedBox(height: 20),
              _buildGenerateButton(),
              const SizedBox(height: 10),
              _buildCopyButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the widget displaying the generated password
  Widget _buildGeneratedPasswordText() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Згенерований пароль:',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          FittedBox(
            child: SelectableText(
              _password.isNotEmpty ? _password : 'Пароль буде тут',
              style: TextStyle(
                fontSize: 24,
                color: Colors.lightBlue[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the password length slider
  Widget _buildPasswordLengthSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Довжина пароля: ${_passwordLength.toInt()}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Slider(
          value: _passwordLength,
          min: 6,
          max: 20,
          divisions: 14,
          activeColor: Colors.lightBlue[200],
          label: _passwordLength.toInt().toString(),
          onChanged: (value) {
            setState(() {
              _passwordLength = value;
            });
          },
        ),
      ],
    );
  }

  // Method to build checkboxes for options
  Widget _buildOptionsCheckboxes() {
    return Column(
      children: [
        CheckboxListTile(
          activeColor: Colors.lightBlue[200],
          title: const Text('Великі літери'),
          value: _includeUppercase,
          onChanged: (bool? value) {
            setState(() {
              _includeUppercase = value ?? true;
            });
          },
        ),
        CheckboxListTile(
          activeColor: Colors.lightBlue[200],
          title: const Text('Малі літери'),
          value: _includeLowercase,
          onChanged: (bool? value) {
            setState(() {
              _includeLowercase = value ?? true;
            });
          },
        ),
        CheckboxListTile(
          activeColor: Colors.lightBlue[200],
          title: const Text('Цифри'),
          value: _includeNumbers,
          onChanged: (bool? value) {
            setState(() {
              _includeNumbers = value ?? true;
            });
          },
        ),
        CheckboxListTile(
          activeColor: Colors.lightBlue[200],
          title: const Text('Спеціальні символи'),
          value: _includeSpecialCharacters,
          onChanged: (bool? value) {
            setState(() {
              _includeSpecialCharacters = value ?? true;
            });
          },
        ),
      ],
    );
  }

  // Method to build the "Generate New Password" button
  Widget _buildGenerateButton() {
    return ElevatedButton(
      onPressed: _generatePassword,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18),
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.lightBlue[200],
        foregroundColor: Colors.black,
      ),
      child: const FittedBox(child: Text('Згенерувати новий пароль')),
    );
  }

  // Method to build the "Copy Password" button
  Widget _buildCopyButton() {
    return ElevatedButton(
      onPressed: _copyToClipboard,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18),
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.green[100],
        foregroundColor: Colors.black,
      ),
      child: const FittedBox(child: Text('Скопіювати пароль')),
    );
  }

  // Method of copying password to clipboard
  void _copyToClipboard() {
    Clipboard.setData(
        ClipboardData(text: _password)); // Copy the password to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Пароль скопійовано!')),
    );
  }
}
