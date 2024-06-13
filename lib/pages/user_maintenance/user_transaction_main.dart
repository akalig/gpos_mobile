import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/layouts/user_maintenance/layout_user_transaction.dart';
import 'package:gpos_mobile/responsive/mobile_pages/user_maintenance/mobile_user_transaction.dart';
import 'package:gpos_mobile/responsive/tablet_pages/user_maintenance/tablet_user_transaction.dart';

class UserTransactionMain extends StatefulWidget {
  const UserTransactionMain({super.key});

  @override
  State<UserTransactionMain> createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransactionMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutUserTransaction(mobileBody: MobileUserTransaction(), tabletBody: TabletUserTransaction(),),
    );
  }
}
