import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_info_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller для каждого TextFormField
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // FocusNode для каждого TextFormField
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _storyFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  bool _hidePass = true;
  bool _hideConfirmPass = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _storyFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  // ---------- Валидаторы ----------
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Имя не может быть пустым';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Введите адрес электронной почты';
    final regex = RegExp(r'^[\w.+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$');
    if (!regex.hasMatch(v.trim())) return 'Некорректный адрес электронной почты';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Введите пароль';
    if (v.length < 6) return 'Пароль должен содержать не менее 6 символов';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Подтвердите пароль';
    if (v != _passController.text) return 'Пароли не совпадают';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Введите номер телефона';
    if (!RegExp(r'^[0-9]+$').hasMatch(v.trim())) {
      return 'Номер телефона должен содержать только цифры';
    }
    return null;
  }

  // ---------- Отправка формы ----------
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text.trim());
      await prefs.setString('phone', _phoneController.text.trim());
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('story', _storyController.text.trim());

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UserInfoPage()),
      );
    }
  }

  // Переход к следующему полю
  void _next(FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  Widget _clearButton(TextEditingController c) => IconButton(
    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
    onPressed: () => c.clear(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Full Name
            TextFormField(
              controller: _nameController,
              focusNode: _nameFocus,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _next(_nameFocus, _phoneFocus),
              validator: _validateName,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'What do people call you?',
                prefixIcon: const Icon(Icons.person),
                suffixIcon: _clearButton(_nameController),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number
            TextFormField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _next(_phoneFocus, _emailFocus),
              validator: _validatePhone,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                hintText: 'Where can we reach you?',
                helperText: 'Phone format: (XXX)XXX-XXXX',
                prefixIcon: const Icon(Icons.call),
                suffixIcon: _clearButton(_phoneController),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _next(_emailFocus, _storyFocus),
              validator: _validateEmail,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                icon: Icon(Icons.mail),
              ),
            ),
            const SizedBox(height: 16),

            // Life Story
            TextFormField(
              controller: _storyController,
              focusNode: _storyFocus,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Life Story',
                helperText: 'Keep it short, this is just a demo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextFormField(
              controller: _passController,
              focusNode: _passFocus,
              obscureText: _hidePass,
              maxLength: 8,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _next(_passFocus, _confirmPassFocus),
              validator: _validatePassword,
              decoration: InputDecoration(
                labelText: 'Password *',
                icon: const Icon(Icons.security),
                suffixIcon: IconButton(
                  icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _hidePass = !_hidePass),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Confirm Password
            TextFormField(
              controller: _confirmPassController,
              focusNode: _confirmPassFocus,
              obscureText: _hideConfirmPass,
              maxLength: 8,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: _validateConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm Password *',
                icon: const Icon(Icons.border_color),
                suffixIcon: IconButton(
                  icon: Icon(
                      _hideConfirmPass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => _hideConfirmPass = !_hideConfirmPass),
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Submit Form',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}