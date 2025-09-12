import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/broker/broker_provider.dart';
import 'package:my_new_project/widgets/broker/add_broker_dialog_form.dart';

class ScreenBrokers extends ConsumerStatefulWidget {
  const ScreenBrokers({super.key});

  @override
  ConsumerState<ScreenBrokers> createState() => _ScreenBrokersState();
}

class _ScreenBrokersState extends ConsumerState<ScreenBrokers> {
  @override
  void initState() {
    super.initState();

    // Load brokers when screen initializes
   
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(brokerProvider.notifier).loadBrokers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brokerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text(
                "Brokers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddBrokerDialogForm(),
                  );
                },
              ),
            ],
          ),
        ),

        // State display
        if (state.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (state.brokers.isEmpty)
          const Center(child: Text("No Broker found."))
        else
          Expanded(
            child: ListView.builder(
              itemCount: state.brokers.length,
              itemBuilder: (context, index) {
                final broker = state.brokers[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(broker.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone: ${broker.phone}"),
                        Text("Address: ${broker.address}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
