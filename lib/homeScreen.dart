import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:trackuser/userDetailsScreen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];
  bool isLoading = true;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
        isLoading = false;
      });
    } else {
      fetchUsers();
    }
  }

  Future<void> fetchUsers() async {
    const String apiUrl = 'https://dummyapi.io/data/v1/user?limit=10';
    const String appId = '61dbf9b1d7efe0f95bc1e1a6';

    final response = await http.get(Uri.parse(apiUrl), headers: {'app-id': appId});

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body)['data'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isConnected
          ? ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index]['firstName'] + ' ' + users[index]['lastName']),
            subtitle: Text(users[index]['email']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(userId: users[index]['id']),
                ),
              );
            },
          );
        },
      )
          : Center(child: Text('No Internet Connection ')),
    );
  }
}
