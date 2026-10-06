import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String _name = '', _phone = '', _email = '', _story = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Чтение данных, сохранённых в SharedPreferences
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _email = prefs.getString('email') ?? '';
      _story = prefs.getString('story') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Information'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Full Name'),
                subtitle: Text(_name),
              ),
              ListTile(
                leading: const Icon(Icons.call),
                title: const Text('Phone Number'),
                subtitle: Text(_phone),
              ),
              ListTile(
                leading: const Icon(Icons.mail),
                title: const Text('Email'),
                subtitle: Text(_email),
              ),
              ListTile(
                leading: const Icon(Icons.notes),
                title: const Text('Life Story'),
                subtitle: Text(_story.isEmpty ? '—' : _story),
              ),
            ],
          ),
        ),
      ),
    );
  }
}