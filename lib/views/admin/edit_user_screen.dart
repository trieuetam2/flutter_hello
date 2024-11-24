import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/services/api_connection.dart';

class EditUserScreen extends StatefulWidget {
  final String productId;

  EditUserScreen({required this.productId});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  // Define text controllers for each form field
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userStatusController = TextEditingController();

  bool _isLoading = false;
  int _selectedRole = 2; // Default value (User)
  int _selectedStatus = 1; // Default value (Active)

  // List of roles to display in the dropdown
  final List<Map<String, dynamic>> _roles = [
    {'label': 'User', 'value': 2},
    {'label': 'Staff', 'value': 3},
  ];
  // List of roles to display in the dropdown
final List<Map<String, dynamic>> _status = [
  {'label': 'Active', 'value': 1},
  {'label': 'Lock', 'value': 2},
];


  // Method to fetch the user's current details
  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${API.editUser}'), // Ensure this is the correct endpoint
        body: {
          'user_id': widget.productId, // Pass the user_id correctly as POST data
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['editUser']); // For debugging purposes

        if (data['editUser'] == true) {
          setState(() {
            _userNameController.text = data['user']['user_name'];
            _userEmailController.text = data['user']['user_email'];
            _selectedRole = data['user']['id_phanquyen'] ?? 2; // Default to '2' if null
            _selectedStatus = data['user']['trangthai'] ?? 1;
            _isLoading = false;
          });
        } else {
          Fluttertoast.showToast(msg: 'User not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to fetch user details');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error occurred while fetching user details');
    }
  }

Future<void> _saveUserDetails() async {
  // Show loading indicator
  setState(() {
    _isLoading = true;
  });

  try {
    final response = await http.post(
      Uri.parse(API.updateUser),  // Ensure this is the correct API endpoint
      body: {
        'user_id': widget.productId,  // Pass user ID as required
        'id_phanquyen': _selectedRole.toString(),  // Send the selected role (as a string)
        'trangthai': _selectedStatus.toString(),  // Send the user status from the text field
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['updateUser'] == true) {
        // Show success message
        Fluttertoast.showToast(msg: 'User updated successfully');
        Navigator.pop(context, true);  // Return to the previous screen
      } else {
        Fluttertoast.showToast(msg: 'Failed to update user');
      }
    } else {
      Fluttertoast.showToast(msg: 'Failed to update user');
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error occurred while saving user details');
  } finally {
    setState(() {
      _isLoading = false;  // Hide loading indicator
    });
  }
}


  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userEmailController.dispose();
    _userStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _userNameController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'User Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _userEmailController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'User Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Dropdown for Role
                    DropdownButtonFormField<int>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                      ),
                      items: _roles.map((role) {
                        return DropdownMenuItem<int>(
                          value: role['value'],
                          child: Text(role['label']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),

DropdownButtonFormField<int>(
  value: _selectedStatus,  // The selected value, which is 1 by default (corresponds to 'Active')
  decoration: InputDecoration(
    labelText: 'Status',  // Label for the dropdown
    border: OutlineInputBorder(),
  ),
  items: _status.map((status) {
    return DropdownMenuItem<int>(
      value: status['value'],  // Corresponds to either 1 or 2 (Active or Lock)
      child: Text(status['label']),  // Displays the corresponding label ('Active' or 'Lock')
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _selectedStatus = value!;  // Update the selected status value
    });
  },
),

                    SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _saveUserDetails,
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
