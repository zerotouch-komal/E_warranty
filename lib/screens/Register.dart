import 'package:e_warranty/provider/all_user_provider.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  bool _isPasswordVisible = false;

  final List<String> _userTypes = [
    'TSM',
    'ASM',
    'SALES_EXECUTIVE',
    'SUPER_DISTRIBUTOR',
    'DISTRIBUTOR',
    'NATIONAL_DISTRIBUTOR',
    'MINI_DISTRIBUTOR',
    'RETAILER',
  ];

  String? name, email, phone, password, userType, alternatePhone;
  String? street, city, state, country, zipCode;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: ScreenUtil.unitHeight * 20),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor:
                isError ? Colors.red.shade600 : Colors.green.shade600,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            elevation: 6,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add User",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader("Personal Information", Icons.person_outline),
              SizedBox(height: 16),
              _buildTextField(
                "Full Name",
                icon: Icons.person_outline,
                onSaved: (v) => name = v,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Name is required";
                  if (value.length < 2)
                    return "Name must be at least 2 characters";
                  return null;
                },
              ),
              _buildTextField(
                "Email Address",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => email = v,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Email is required";
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              _buildTextField(
                "Phone Number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onSaved: (v) => phone = v,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Phone number is required";
                  if (value.length < 10)
                    return "Please enter a valid phone number";
                  return null;
                },
              ),
              _buildTextField(
                "Alternate Phone (Optional)",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onSaved: (v) => alternatePhone = v,
                isRequired: false,
              ),
              _buildTextField(
                "Password",
                icon: Icons.lock_outline,
                obscure: !_isPasswordVisible,
                onSaved: (v) => password = v,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Password is required";
                  if (value.length < 6)
                    return "Password must be at least 6 characters";
                  return null;
                },
              ),
              _buildDropdown(
                "User Type",
                _userTypes,
                Icons.work_outline,
                (v) => setState(() => userType = v),
              ),

              SizedBox(height: 32),

              _buildSectionHeader(
                "Address Information",
                Icons.location_on_outlined,
              ),
              SizedBox(height: 16),
              _buildTextField(
                "Street Address",
                icon: Icons.home_outlined,
                onSaved: (v) => street = v,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      "City",
                      icon: Icons.location_city_outlined,
                      onSaved: (v) => city = v,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      "State",
                      icon: Icons.map_outlined,
                      onSaved: (v) => state = v,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      "Country",
                      icon: Icons.public_outlined,
                      onSaved: (v) => country = v,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      "Zip Code",
                      icon: Icons.local_post_office_outlined,
                      keyboardType: TextInputType.number,
                      onSaved: (v) => zipCode = v,
                    ),
                  ),
                ],
              ),

              SizedBox(height: ScreenUtil.unitHeight * 20),

              SizedBox(
                height: ScreenUtil.unitHeight * 60,
                child:
                    provider.isLoading
                        ? Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: SizedBox(
                              height: ScreenUtil.unitHeight * 20,
                              width: ScreenUtil.unitHeight * 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        )
                        : ElevatedButton(
                          onPressed: _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label, {
    IconData? icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
    bool isRequired = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              icon != null
                  ? Icon(
                    icon,
                    color: colorScheme.onSurface.withOpacity(0.6),
                    size: 20,
                  )
                  : null,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator:
            validator ??
            (isRequired
                ? (value) =>
                    value == null || value.isEmpty ? "$label is required" : null
                : null),
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    IconData icon,
    ValueChanged<String?>? onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: userType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        items:
            items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e.replaceAll('_', ' '),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                )
                .toList(),
        validator:
            (value) =>
                value == null || value.isEmpty ? "Please select $label" : null,
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    print('Register button pressed');

    if (_formKey.currentState!.validate()) {
      print('Form validated');

      _formKey.currentState!.save();

      print('Values: $name, $email, $phone, $password, $userType');

      final provider = Provider.of<RegisterProvider>(context, listen: false);

      try {
        await provider.registerUser(
          name: name!,
          email: email!,
          phone: phone!,
          password: password!,
          userType: userType!,
          alternatePhone: alternatePhone ?? '',
          street: street!,
          city: city!,
          state: state!,
          country: country!,
          zipCode: zipCode!,
        );

        if (!mounted) return;

        if (provider.registerResponse?.success == true) {
          _showSnackBar("Registration successful! Welcome aboard!");

          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).maybePop();
            }
          });
        } else {
          String errorMessage =
              provider.registerResponse?.message ??
              "Registration failed. Please try again.";
          _showSnackBar(errorMessage, isError: true);
          print('Registration failed: $errorMessage');
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar(
            "An error occurred. Please check your connection and try again.",
            isError: true,
          );
        }
        print('Registration error: $e');
      }
    } else {
      _showSnackBar(
        "Please fill in all required fields correctly.",
        isError: true,
      );
      print('Form validation failed');

      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
