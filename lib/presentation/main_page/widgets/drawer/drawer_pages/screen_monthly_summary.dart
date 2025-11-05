import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import flutter_hooks
import 'package:flutter_query/flutter_query.dart'; // Import flutter_query
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Use hooks_riverpod for HookConsumerWidget
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/monthlysummary.dart';
import 'package:my_new_project/core/query/query_client.dart'; // Assuming you have this for QueryClient
import 'package:my_new_project/infrastructure/monthlysummary/monthlysummary_repositary.dart';
import 'package:my_new_project/widgets/reusable/custom_header_summary.dart';
import 'package:my_new_project/widgets/reusable/custom_header_buttons.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenMonthlySummary extends HookConsumerWidget { // Changed to HookConsumerWidget
  const ScreenMonthlySummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef ref
    final selectedTab = useState('sales'); // Use useState for local state

    // Initialize QueryClient (if not already done globally)
    final queryClient = ref.read(queryClientProvider);

    // Use useQuery for data fetching and caching
    final query = useQuery<List<MonthlySummary>, dynamic>(
      'monthlySummaries', // Unique cache key for monthly summaries
      (key) async {
        final repo = ref.read(monthlySummaryRepositoryProvider);
        return await repo.getMonthlySummaries();
      },
      staleDuration: const Duration(minutes: 5), // Cache for 5 minutes
    );

    final summaries = query.state.data ?? []; // Get data from query state

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Custom Header (Same as Daily)
            CustomHeaderSummary(
              title: 'Monthly Summary',
              headerContent: SummaryHeaderButtons(
                selectedTab: selectedTab.value, // Access value of useState
                onTabSelected: (tab) => selectedTab.value = tab, // Update value
                onFilter: () {
                  // TODO: open filters if needed
                },
                onRefresh: () {
                  query.refetch(); // Trigger a manual refresh
                },
              ),
            ),

            KHeight16,

            /// 🔹 Summary List (Using OutputCard)
            Expanded(
              child: query.state.status.isFetching // Check fetching status
                  ? const Center(child: CircularProgressIndicator())
                  : query.state.status.isFailure // Check for errors
                      ? Center(
                          child: Text(
                            'Error: ${query.state.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : summaries.isEmpty // Check if data is empty
                          ? const Center(child: Text('No monthly reports found'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: summaries.length,
                              itemBuilder: (context, index) {
                                final summary = summaries[index];

                                // 🔸 Map data based on tab
                                String subtitle = '';
                                double? amount;
                                double? received;
                                double? balance;
                                String receivedLabel = ''; // Added receivedLabel for consistency

                                if (selectedTab.value == 'sales') {
                                  subtitle = 'Sales: ${summary.saleCount}';
                                  amount = summary.saleReceived + summary.salePending;
                                  received = summary.saleReceived;
                                  balance = summary.salePending;
                                  receivedLabel = 'Received';
                                } else if (selectedTab.value == 'purchases') {
                                  subtitle = 'Purchases: ${summary.purchaseCount}';
                                  amount = summary.purchasePaid + summary.purchasePending;
                                  received = summary.purchasePaid;
                                  balance = summary.purchasePending;
                                  receivedLabel = 'Paid';
                                } else if (selectedTab.value == 'expenses') {
                                  subtitle = 'Expenses: ${summary.expenseCount}';
                                  amount = summary.expenseAmount;
                                  received = summary.expensePaid;
                                  balance = summary.expenseBalance;
                                  receivedLabel = 'Paid';
                                }

                                return OutputCard(
                                  title: '${summary.month} ${summary.year}',
                                  subtitle: subtitle,
                                  amount: amount,
                                  received: received,
                                  balance: balance,
                                  receivedLabel: receivedLabel,
                                  isSummaryView: true,
                                  showMenu: false,
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


/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/monthlysummary/monthlysummary_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/monthlysummary.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/custom_header_buttons.dart';
import 'package:my_new_project/widgets/reusable/custom_header_summary.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenMonthlySummary extends ConsumerStatefulWidget {
  const ScreenMonthlySummary({super.key});

  @override
  ConsumerState<ScreenMonthlySummary> createState() => _ScreenMonthlySummaryState();
}

class _ScreenMonthlySummaryState extends ConsumerState<ScreenMonthlySummary> {
  String selectedTab = 'sales'; // Default tab

  @override
  Widget build(BuildContext context) {
    final monthlySummaryState = ref.watch(monthlySummaryProvider);
    final summaries = monthlySummaryState.summaries;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom header (reused)
           CustomHeaderSummary(
             title: 'Monthly Summary',
            //  onBack: () {},
             headerContent: SummaryHeaderButtons(
               selectedTab: selectedTab,
               onTabSelected: (tab) {
                 setState(() {
                   selectedTab = tab;
                   // Optional: Filter your data based on selectedTab
                 });
               },
               onFilter: () {
                 // handle filter logic
               },
               onRefresh: () {
                 // handle refresh logic
               },
             ),
           ),



            KHeight16,

            // Main list of summaries
            Expanded(
              child: monthlySummaryState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : summaries.isEmpty
                      ? const Center(child: Text('No monthly reports found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: summaries.length,
                          itemBuilder: (context, index) {
                            final summary = summaries[index];

                            // Dynamic mapping based on selected tab
                            String subtitle = '';
                            double? amount;
                            double? received;
                            double? balance;

                            if (selectedTab == 'sales') {
                              subtitle = 'Sales: ${summary.saleCount}';
                              amount = summary.saleReceived + summary.salePending;
                              received = summary.saleReceived;
                              balance = summary.salePending;
                            } else if (selectedTab == 'purchases') {
                              subtitle = 'Purchases: ${summary.purchaseCount}';
                              amount = summary.purchasePaid + summary.purchasePending;
                              received = summary.purchasePaid;
                              balance = summary.purchasePending;
                            } else if (selectedTab == 'expenses') {
                              subtitle = 'Expenses: ${summary.expenseCount}';
                              amount = summary.expenseAmount;
                              received = summary.expensePaid;
                              balance = summary.expenseBalance;
                            }

                            return OutputCard(
                              title: '${summary.month} ${summary.year}',
                              subtitle: subtitle,
                              amount: amount,
                              received: received,
                              balance: balance,
                              isSummaryView: true,
                              showMenu: false,
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