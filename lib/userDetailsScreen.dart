import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  UserDetailsScreen({required this.userId});

  Future<Map<String, dynamic>> fetchUserDetails() async {
    const String appId = '61dbf9b1d7efe0f95bc1e1a6';
    final response = await http.get(Uri.parse('https://dummyapi.io/data/v1/user/$userId'),
        headers: {'app-id': appId});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(' Failed to load user details ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${user['firstName']} ${user['lastName']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Email: ${user['email']}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Image.network(user['picture']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
