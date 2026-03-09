import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileHeader extends StatefulWidget {
  const UserProfileHeader({super.key});

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('user_image');
      final name = prefs.getString('user_name');
      final email = prefs.getString('user_email');
      if (mounted) {
        setState(() {
          if (imagePath != null) {
            _image = File(imagePath);
          }
          if (name != null) {
            _name = name;
          }
          if (email != null) {
            _email = email;
          }
        });
      }
    } catch (e) {
        if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to load user data')),
            );
        }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
        final pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
        final file = File(pickedFile.path);
        if (mounted) {
            setState(() {
                _image = file;
            });
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_image', file.path);
        }
    } catch (e) {
        if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to pick image')),
            );
        }
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _image != null ? FileImage(_image!) : null,
            child: _image == null
                ? const Icon(
                    Icons.person,
                    size: 50,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          _email,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
