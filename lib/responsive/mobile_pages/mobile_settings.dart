import 'package:flutter/material.dart';
import 'package:gpos_mobile/database/database_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';
import '../../components/authentication_textfield.dart';
import '../../components/register_button.dart';
import '../../components/save_button.dart';

class MobileSettings extends StatefulWidget {
  const MobileSettings({Key? key}) : super(key: key);

  @override
  _MobileSettingsState createState() => _MobileSettingsState();
}

class _MobileSettingsState extends State<MobileSettings> {
  List<Map<String, dynamic>> _companyDetails = [];
  bool _isLoading = true;
  late TextEditingController _companyNameController;
  late TextEditingController _companyAddressController;
  late TextEditingController _companyMobileNumberController;
  late TextEditingController _companyEmailController;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController();
    _companyAddressController = TextEditingController();
    _companyMobileNumberController = TextEditingController();
    _companyEmailController = TextEditingController();

    _refreshCompanyDetails();
  }

  void _refreshCompanyDetails() async {
    final data = await SQLHelper.getCompanyDetailsData();
    setState(() {
      _companyDetails = data;
      _isLoading = false;
    });

    if (_companyDetails.isNotEmpty) {
      final existingProductType = _companyDetails.first;
      _companyNameController.text = existingProductType['company_name'];
      _companyAddressController.text = existingProductType['company_address'];
      _companyMobileNumberController.text =
          existingProductType['company_mobile_number'];
      _companyEmailController.text = existingProductType['company_email'];
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _companyMobileNumberController.dispose();
    _companyEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('SETTINGS'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 120 / 9,
                  child: Container(
                    color: Colors.deepPurple[200],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Company Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AuthenticationTextField(
                controller: _companyNameController,
                hintText: 'Company Name',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              AuthenticationTextField(
                controller: _companyAddressController,
                hintText: 'Address',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              AuthenticationTextField(
                controller: _companyMobileNumberController,
                hintText: 'Mobile Number',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              AuthenticationTextField(
                controller: _companyEmailController,
                hintText: 'Email Address',
                obscureText: false,
              ),
              const SizedBox(height: 25),
              SaveButton(
                onTap: () {

                },
              ),
            ],
          ),
        ),
      ),
      drawer: const SidebarMenu(),
    );
  }
}
