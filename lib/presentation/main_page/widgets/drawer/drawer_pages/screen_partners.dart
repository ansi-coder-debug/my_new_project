import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/partnerships/add_partner_form.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class PartnersPage extends ConsumerStatefulWidget {
  const PartnersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PartnersPage> createState() => _ScreenPartnersState();
}

class _ScreenPartnersState extends ConsumerState<PartnersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(partnerProvider.notifier).loadPartners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final partnerState = ref.watch(partnerProvider);
    final partners = partnerState.partners;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            CustomHeader(
              title: "Partners",
              onBack: () {},
              onFilter: () {
                // TODO: Implement filter
              },
              onSearch: () {
                // TODO: Implement search
              },
              onRefresh: () {
                ref.read(partnerProvider.notifier).loadPartners();
              },
              showAdd: true,
              onAdd: () {
                showDialog(context: context, builder: (_) => AddPartnerForm());
              },
            ),
            KHeight,

            // Body
            Expanded(
              child: partnerState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : partners.isEmpty
                  ? const Center(child: Text("No partners found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: partners.length,
                      itemBuilder: (context, index) {
                        final partner = partners[index];

                        return OutputCard(
                          title: partner.name,
                          subtitle: partner.phone!,
                          address: partner.address,
                           onView: () {
                            // You can show a dialog or navigate to a detail screen
                          },
                          onEdit: () {
                            
                          },
                          onDelete: () {
                         
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/*// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/partner/partner_provider.dart';
// import 'package:my_new_project/application/partner/partner_state.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/widgets/partnerships/add_partner_form.dart';
// import 'package:my_new_project/widgets/reusable/custom_header.dart';

// class PartnersPage extends ConsumerStatefulWidget {
//   const PartnersPage({Key? key}) : super(key: key);

//   @override
//   ConsumerState<PartnersPage> createState() => _PartnersPageState();
// }

// class _PartnersPageState extends ConsumerState<PartnersPage> {
//   @override
//   void initState() {
//     super.initState();
//     // 👇 Fetch partners when page opens

//     // Future.microtask(() {
//     //   ref.read(partnerProvider.notifier).loadPartners();
//     // });

//     //fetch when app opens
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(partnerProvider.notifier).loadPartners();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final partnerState = ref.watch(partnerProvider);
//     final partners = partnerState.partners;

//       // appBar: AppBar(title: const Text('Partners')),
//      return Scaffold(
//       body:SafeArea(
//         child:Column(
//           children: [
//             CustomHeader(
//               title:"Partners",
//               onBack: () {
//                 // Optional back action
//               },
//                onFilter: () {
//                 // TODO: Open filter
//               },
//               onRefresh: () {
//                 ref.read(partnerProvider.notifier).loadPartners();
//               },
//               onSearch: () {
//                 // TODO: Open search
//               },
//               showAdd: true,
//               onAdd: () {
//                 showDialog(
//                   context: context,
//                   builder: (_) =>  AddPartnerForm(),
//                 );
//               },
//             ),
//             KHeight,

//       Expanded(
//         child:
//        partners.isEmpty
//           ? const Center(child: Text('No partners found'))
//           : ListView.builder(
//               itemCount: partners.length,
//               itemBuilder: (context, index) {
//                 final partner = partners[index];
//                 return ListTile(
//                   title: Text(partner.name ?? ''),
//                   subtitle: Text(partner.phone ?? ''),
//                 );
//               },
//             ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     showModalBottomSheet(
//       //       context: context,
//       //       isScrollControlled: true,
//       //       builder: (_) => Padding(
//       //         padding: EdgeInsets.only(
//       //           bottom: MediaQuery.of(context).viewInsets.bottom,
//       //         ),
//       //         child: AddPartnerForm(),
//       //       ),
//       //     );
//       //   },
//       //   child: const Icon(Icons.add),
//       // ),
//       ),
//       ],
//         ),
//         ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/partnerships/add_partner_form.dart';

class  PartnersPage extends ConsumerStatefulWidget {
  const PartnersPage ({Key? key}) : super(key: key);

  @override
  ConsumerState< PartnersPage> createState() => _ScreenPartnersState();
}

class _ScreenPartnersState extends ConsumerState< PartnersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(partnerProvider.notifier).loadPartners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final partnerState = ref.watch(partnerProvider);
    final partners = partnerState.partners;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            CustomHeader(
              title: "Partners",
              onBack: () {},
              onFilter: () {
                // TODO: Implement filter
              },
              onSearch: () {
                // TODO: Implement search
              },
              onRefresh: () {
                ref.read(partnerProvider.notifier).loadPartners();
              },
              showAdd: true,
              onAdd: () {
                showDialog(context: context, builder: (_) => AddPartnerForm());
              },
            ),
            KHeight,

            // Body
            Expanded(
              child: partnerState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : partners.isEmpty
                  ? const Center(child: Text("No partners found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: partners.length,
                      itemBuilder: (context, index) {
                        final partner = partners[index];

                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name + Menu
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        partner.name ?? "Unnamed Partner",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF1B1B3A),
                                        ),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          // TODO: Implement edit
                                        } else if (value == 'delete') {
                                          // TODO: Implement delete
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                               
                                Text(
                                  "${partner.address ?? 'N/A'}",
                                  ),

                                // Phone
                                Text(
                                  " ${partner.phone ?? 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
