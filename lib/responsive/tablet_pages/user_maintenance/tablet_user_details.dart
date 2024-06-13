import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class TabletUserDetails extends StatefulWidget {
  const TabletUserDetails({super.key});

  @override
  State<TabletUserDetails> createState() => _TabletUserDetailsState();
}

class _TabletUserDetailsState extends State<TabletUserDetails> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDrawerOpen = true;
  List<Map<String, dynamic>> _userList = [];
  bool _isLoading = true;
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController suffixNameController;
  late TextEditingController userNameController;
  late TextEditingController passwordController;
  late TextEditingController userTypeController;
  late TextEditingController confirmPasswordController;
  String userType = '';

  void _refreshUserList() async {
    final data = await SQLHelper.getUsersData();
    setState(() {
      _userList = data;
      _isLoading = false;
    });
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _refreshUserList();
    firstNameController = TextEditingController();
    middleNameController = TextEditingController();
    lastNameController = TextEditingController();
    suffixNameController = TextEditingController();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    userTypeController = TextEditingController();
  }

  /// * ADD OR UPDATE USER DIALOG CLASS **
  void addUserDialog(BuildContext context, int? id) async {
    if (id != null) {
      final existingUser =
      _userList.firstWhere((element) => element['id'] == id);
      firstNameController.text = existingUser['first_name'];
      middleNameController.text = existingUser['middle_name'];
      lastNameController.text = existingUser['last_name'];
      suffixNameController.text = existingUser['suffix_name'];
      userNameController.text = existingUser['username'];
      userType = existingUser['user_type'];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add User / Update User'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(hintText: 'First Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: middleNameController,
                  decoration: const InputDecoration(hintText: 'Middle Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(hintText: 'Last Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: suffixNameController,
                  decoration: const InputDecoration(hintText: 'Suffix Name'),
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: userType.isNotEmpty
                      ? userType
                      : null,
                  hint: const Text('User Type'),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'admin',
                      child: Text('Admin'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'manager',
                      child: Text('Manager'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'cashier',
                      child: Text('Cashier'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      userType = newValue ?? '';
                    });
                  },
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(hintText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(hintText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(hintText: 'Confirm Password'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (id == null) {
                  await _addUser();
                }

                if (id != null) {
                  await _updateUser(id);
                }

                firstNameController.text = '';
                middleNameController.text = '';
                lastNameController.text = '';
                suffixNameController.text = '';
                userNameController.text = '';
                passwordController.text = '';
                confirmPasswordController.text = '';
                userTypeController.text = '';

                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Submit' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                firstNameController.text = '';
                middleNameController.text = '';
                lastNameController.text = '';
                suffixNameController.text = '';
                userNameController.text = '';
                passwordController.text = '';
                confirmPasswordController.text = '';
                userTypeController.text = '';
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// * ADD USER CLASS **
  Future<void> _addUser() async {
    await SQLHelper.createUserAccount(
        firstNameController.text,
        middleNameController.text,
        lastNameController.text,
        suffixNameController.text,
        userNameController.text,
        passwordController.text,
        userType);

    _refreshUserList();
  }

  /// * UPDATE USER CLASS **
  Future<void> _updateUser(int id) async {
    await SQLHelper.updateUser(
        id,
        firstNameController.text,
        middleNameController.text,
        lastNameController.text,
        suffixNameController.text,
        userNameController.text,
        passwordController.text,
        'admin');

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated a user.'),
    ));
    _refreshUserList();
  }

  /// * DELETE USER CLASS **
  void _deleteUser(int id) async {
    await SQLHelper.deleteUser(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a user.'),
    ));
    _refreshUserList();
  }

  /// * DELETE USER DIALOG CLASS **
  void deleteUserDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this User?'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteUser(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('USER DETAILS'),
        centerTitle: true,
        // Add hamburger icon to toggle the drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: _isDrawerOpen
                ? const Icon(Icons.menu_open)
                : const Icon(Icons.menu),
            onPressed: _toggleDrawer,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: _isDrawerOpen ? 200 : 0),
            child: Row(
              children: [
                // First column
                Expanded(
                  child: Column(
                    children: [
                      // youtube video
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: 120 / 9,
                          child: Container(
                            color: Colors.deepPurple[200],
                          ),
                        ),
                      ),

                      /*** ADD USER BUTTON ***/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              /*** ADD USER DIALOG ***/
                              addUserDialog(context, null);
                            },
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Text(
                                  "+ Add User",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /*** USER LIST ***/
                      Expanded(
                        child: _userList.isNotEmpty
                            ? ListView.builder(
                          itemCount: _userList.length,
                          itemBuilder: (context, index) => Card(
                            color: Colors.white70,
                            margin: const EdgeInsets.all(5),
                            child: ListTile(
                              title: Text(_userList[index]['first_name'] + ' ' + _userList[index]['last_name']),
                              subtitle: Text(_userList[index]['user_type']),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => addUserDialog(
                                          context, _userList[index]['id']),
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () => deleteUserDialog(
                                          context, _userList[index]['id']),
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                            : const Center(
                          child: Text("No product types available."),
                        ),
                      ),
                    ],
                  ),
                ),
                // second column
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 50,
                    color: Colors.deepPurple[300],
                  ),
                ),
              ],
            ),
          ),
          if (_isDrawerOpen)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: 200,
                child: SidebarMenu(),
              ),
            ),
        ],
      ),
    );
  }
}
