import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/application/partner/partner_state.dart';

import 'package:my_new_project/widgets/partnerships/add_partner_form.dart';

class PartnersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final partners = ref.watch(partnerProvider);
    final PartnerState = ref.watch(partnerProvider);

    final partners = PartnerState.partners;

    // final partnershipState = ref.watch(partnershipProvider);
    // final partners = partnershipState.partnerships;

    return Scaffold(
      appBar: AppBar(title: Text('Partners')),
      body: ListView.builder(
        itemCount: partners.length,
        itemBuilder: (context, index) {
          final partner = partners[index];
          return ListTile(
            title: Text(partner.name ?? ''), // partner name
            subtitle: Text(partner.phone ?? ''), // assuming phone field exists
            // You can add buttons here for edit/delete if needed
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: AddPartnerForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
