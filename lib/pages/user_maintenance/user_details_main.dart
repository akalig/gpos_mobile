import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/layouts/user_maintenance/layout_user_details.dart';
import 'package:gpos_mobile/responsive/mobile_pages/user_maintenance/mobile_user_details.dart';
import 'package:gpos_mobile/responsive/tablet_pages/user_maintenance/tablet_user_details.dart';

class UserDetailsMain extends StatefulWidget {
  const UserDetailsMain({super.key});

  @override
  State<UserDetailsMain> createState() => _ProductTypesState();
}

class _ProductTypesState extends State<UserDetailsMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutUserDetails(mobileBody: MobileUserDetails(), tabletBody: TabletUserDetails(),),
    );
  }
}
