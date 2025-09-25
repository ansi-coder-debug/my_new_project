import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/advance/advance_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/advance/add_advance_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';



class ScreenAdvance extends ConsumerWidget {
  const ScreenAdvance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advanceState = ref.watch(advanceProvider);
    final advances = advanceState.advances;

    print('👀 Advances in UI: ${advances.map((a) => a.buyerName).toList()}');

   
      // appBar: AppBar(
      //   title: const Text('Advances'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.add),
      //       onPressed: () {
      //         showDialog(context: context, builder: (_) => AddAdvanceDialog());
      //       },
      //     ),
      //   ],
      // ),
       return Scaffold(
      body:SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title:"Advances",
               onBack: (){
                //last index wanna do at later 
              },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(advanceProvider.notifier).loadAdvances();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd:(){
                showDialog(
                  context: context,
                   builder:(_) =>AddAdvanceDialog(),
                    );
              }    
               ),
               KHeight,
      
      
      
      Expanded(
        child: 
      
       advanceState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : advances.isEmpty
          ? const Center(child: Text("No advances found"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: advances.length,
              itemBuilder: (context, index) {
                final advance = advances[index];

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
                        // Buyer Name + Menu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                advance.buyerName.toUpperCase(),
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
                                  // TODO: Edit advance
                                } else if (value == 'delete') {
                                  // TODO: Delete advance
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
                        const SizedBox(height: 8),

                        // Vehicle name (assuming you have vehicle info on the advance)
                        Text(
                          "Vehicle: ${advance.buyerName ?? 'Unknown'}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Amount
                        Text(
                          "Amount: ₹${advance.amount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Date
                        Text(
                          "Date: ${advance.date.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Buyer phone and address (optional display)
                        Text(
                          "Phone: ${advance.buyerPhone}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if ((advance.buyerAddress ?? '').trim().isNotEmpty)
                          Text(
                            advance.buyerAddress!,
                            style: const TextStyle(
                              fontSize: 13,
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
