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
  List<Map<String, dynamic>> _receiptFooter = [];
  bool _isLoading = true;
  late TextEditingController _companyNameController;
  late TextEditingController _companyAddressController;
  late TextEditingController _companyMobileNumberController;
  late TextEditingController _companyEmailController;
  late TextEditingController _receiptFooterLineOneController;
  late TextEditingController _receiptFooterLineTwoController;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController();
    _companyAddressController = TextEditingController();
    _companyMobileNumberController = TextEditingController();
    _companyEmailController = TextEditingController();
    _receiptFooterLineOneController = TextEditingController();
    _receiptFooterLineTwoController = TextEditingController();

    _refreshCompanyDetails();
    _refreshReceiptFooter();
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

  void _refreshReceiptFooter() async {
    final data = await SQLHelper.getReceiptFooter();
    setState(() {
      _receiptFooter = data;
      _isLoading = false;
    });

    if (_receiptFooter.isNotEmpty) {
      final existingProductType = _receiptFooter.first;
      _receiptFooterLineOneController.text = existingProductType['line_one'];
      _receiptFooterLineTwoController.text = existingProductType['line_two'];
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _companyMobileNumberController.dispose();
    _companyEmailController.dispose();
    _receiptFooterLineOneController.dispose();
    _receiptFooterLineTwoController.dispose();
    super.dispose();
  }

  /// * UPDATE COMPANY DETAILS CLASS **
  Future<void> _updateCompanyDetails() async {
    await SQLHelper.updateCompanyDetails(
        _companyNameController.text,
        _companyAddressController.text,
        _companyMobileNumberController.text,
        _companyEmailController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated'),
    ));
    _refreshCompanyDetails();
  }

  /// * UPDATE RECEIPT FOOTER CLASS **
  Future<void> _updateReceiptFooter() async {
    await SQLHelper.updateReceiptFooter(_receiptFooterLineOneController.text,
        _receiptFooterLineTwoController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated'),
    ));
    _refreshReceiptFooter();
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
                onTap: () async {
                  await _updateCompanyDetails();
                },
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Receipt Footer Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AuthenticationTextField(
                controller: _receiptFooterLineOneController,
                hintText: 'Footer Line One',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              AuthenticationTextField(
                controller: _receiptFooterLineTwoController,
                hintText: 'Footer Line Two',
                obscureText: false,
              ),
              const SizedBox(height: 25),
              SaveButton(
                onTap: () async {
                  await _updateReceiptFooter();
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
