import 'package:e_warranty/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.changePassword(
        context: context,
        currentPassword: _currentController.text.trim(),
        newPassword: _newController.text.trim(),
        confirmPassword: _confirmController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(_currentController, "Current Password"),
              const SizedBox(height: 16),
              _buildPasswordField(_newController, "New Password"),
              const SizedBox(height: 16),
              _buildPasswordField(
                _confirmController,
                "Confirm Password",
                validator: (value) {
                  if (value != _newController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text("Save"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "$label is required";
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
