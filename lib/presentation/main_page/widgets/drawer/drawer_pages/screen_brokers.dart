import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/broker/broker_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/broker/add_broker_dialog_form.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenBrokers extends ConsumerStatefulWidget {
  const ScreenBrokers({super.key});

  @override
  ConsumerState<ScreenBrokers> createState() => _ScreenBrokersState();
}

class _ScreenBrokersState extends ConsumerState<ScreenBrokers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(brokerProvider.notifier).loadBrokers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brokerProvider);
    final brokers = state.brokers;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Brokers",
              onBack: () {
                //last index wanna do at later
              },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(brokerProvider.notifier).loadBrokers();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => AddBrokerDialogForm(),
                );
              },
            ),
            KHeight,

            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : brokers.isEmpty
                  ? const Center(child: Text("No brokers found."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: brokers.length,
                      itemBuilder: (context, index) {
                        final broker = brokers[index];

                        return OutputCard(
                          title: broker.name,
                          subtitle: broker.phone,
                          address: broker.address,
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

// import 'package:my_new_project/application/broker/broker_provider.dart';
// import 'package:my_new_project/widgets/broker/add_broker_dialog_form.dart';

// class ScreenBrokers extends ConsumerStatefulWidget {
//   const ScreenBrokers({super.key});

//   @override
//   ConsumerState<ScreenBrokers> createState() => _ScreenBrokersState();
// }

// class _ScreenBrokersState extends ConsumerState<ScreenBrokers> {
//   @override
//   void initState() {
//     super.initState();

//     // Load brokers when screen initializes
   
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     ref.read(brokerProvider.notifier).loadBrokers();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(brokerProvider);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               const Text(
//                 "Brokers",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const Spacer(),
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => const AddBrokerDialogForm(),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),

//         // State display
//         if (state.isLoading)
//           const Center(child: CircularProgressIndicator())
//         else if (state.brokers.isEmpty)
//           const Center(child: Text("No Broker found."))
//         else
//           Expanded(
//             child: ListView.builder(
//               itemCount: state.brokers.length,
//               itemBuilder: (context, index) {
//                 final broker = state.brokers[index];
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(broker.name),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Phone: ${broker.phone}"),
//                         Text("Address: ${broker.address}"),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/broker/broker_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/broker/add_broker_dialog_form.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';

class ScreenBrokers extends ConsumerStatefulWidget {
  const ScreenBrokers({super.key});

  @override
  ConsumerState<ScreenBrokers> createState() => _ScreenBrokersState();
}

class _ScreenBrokersState extends ConsumerState<ScreenBrokers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(brokerProvider.notifier).loadBrokers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brokerProvider);
    final brokers = state.brokers;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Brokers",
              onBack: (){
                //last index wanna do at later 
              },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(brokerProvider.notifier).loadBrokers();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd:(){
                showDialog(
                  context: context,
                   builder:(_) =>AddBrokerDialogForm(),
                    );
              }    
            ),
            KHeight,

            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : brokers.isEmpty
                      ? const Center(child: Text("No brokers found."))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: brokers.length,
                          itemBuilder: (context, index) {
                            final broker = brokers[index];

                            return Card(
                              
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            broker.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1B1B3A),
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            // TODO: Add edit/delete functionality
                                          },
                                          itemBuilder: (context) => const [
                                            PopupMenuItem(
                                                value: 'edit', child: Text('Edit')),
                                            PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete')),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Phone: ${broker.phone}",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      "Address: ${broker.address}",
                                      style: const TextStyle(color: Colors.grey),
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
