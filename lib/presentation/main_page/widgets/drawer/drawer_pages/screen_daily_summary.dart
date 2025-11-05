import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart'; // ✅ Flutter Query
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/dailysummary.dart';
import 'package:my_new_project/infrastructure/dailysummary/dailysummary_repositary.dart';
import 'package:my_new_project/widgets/reusable/custom_header_summary.dart';
import 'package:my_new_project/widgets/reusable/custom_header_buttons.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenDailySummary extends HookConsumerWidget {
  const ScreenDailySummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState('sales');

    final query = useQuery<List<DailySummary>, dynamic>(
      'dailySummaries', // cache key
      (key) async {
        final repo = ref.read(dailySummaryRepositoryProvider);
        return await repo.getDailySummaries();
      },
    );
    final summaries = query.state.data ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Custom Header (Same as Monthly)
            CustomHeaderSummary(
              title: 'Daily Summary',
              headerContent: SummaryHeaderButtons(
                selectedTab: selectedTab.value,
                onTabSelected: (tab) => selectedTab.value = tab,
                onFilter: () {
                  // TODO: open filters if needed
                },
                onRefresh: () {
                  query.refetch(); // ✅ this triggers a fresh fetch manually
                },
              ),
            ),

            KHeight16,

            /// 🔹 Summary List (Using OutputCard)
            Expanded(
              child: query.state.status.isFetching
                  ? const Center(child: CircularProgressIndicator())
                  : query.state.status.isFailure
                  ? Center(
                      child: Text(
                        'Error: ${query.state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : (query.state.data ?? []).isEmpty
                  ? const Center(child: Text('No daily reports found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: summaries.length,
                      itemBuilder: (context, index) {
                        final summary = summaries[index];

                        // 🔸 Parse date
                        final date = DateTime.parse(summary.date);
                        final title = '${date.day}-${date.month}-${date.year}';

                        // 🔸 Map data based on tab
                        String subtitle = '';
                        double? amount;
                        double? received;
                        double? balance;
                        String receivedLabel = '';

                        if (selectedTab.value == 'sales') {
                          subtitle = 'Sales: ${summary.saleCount}';
                          amount = summary.saleReceived + summary.salePending;
                          received = summary.saleReceived;
                          balance = summary.salePending;
                          receivedLabel = 'Received';
                        } else if (selectedTab.value == 'purchases') {
                          subtitle = 'Purchases: ${summary.purchaseCount}';
                          amount =
                              summary.purchasePaid + summary.purchasePending;
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
                          title: title,
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



/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/dailysummary/dailysummary_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header_summary.dart';
import 'package:my_new_project/widgets/reusable/custom_header_buttons.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';
import 'package:flutter_query/flutter_query.dart'; // ✅ NEW


class ScreenDailySummary extends ConsumerStatefulWidget {
  const ScreenDailySummary({super.key});

  @override
  ConsumerState<ScreenDailySummary> createState() => _ScreenDailySummaryState();
}

class _ScreenDailySummaryState extends ConsumerState<ScreenDailySummary> {
  String selectedTab = 'sales';

  @override
  Widget build(BuildContext context) {
    final dailySummaryState = ref.watch(dailySummaryProvider);
    final summaries = dailySummaryState.summaries;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Custom Header (Same as Monthly)
            CustomHeaderSummary(
              title: 'Daily Summary',
              // onBack: (){},
              headerContent: SummaryHeaderButtons(
                selectedTab: selectedTab,
                onTabSelected: (tab) {
                  setState(() {
                    selectedTab = tab;
                  });
                },
                onFilter: () {
                  // TODO: Open filters
                },
                onRefresh: () {
                  ref.read(dailySummaryProvider.notifier).loadDailySummaries();
                },
              ),
            ),

            KHeight16,

            /// 🔹 Summary List (Using OutputCard)
            Expanded(
              child: dailySummaryState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : summaries.isEmpty
                      ? const Center(child: Text('No daily reports found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: summaries.length,
                          itemBuilder: (context, index) {
                            final summary = summaries[index];

                            // 🔸 Parse date
                            final date = DateTime.parse(summary.date);
                            final title = '${date.day}-${date.month}-${date.year}';

                            // 🔸 Map data based on tab
                            String subtitle = '';
                            double? amount;
                            double? received;
                            double? balance;
                            String receivedLabel = '';

                            if (selectedTab == 'sales') {
                              subtitle = 'Sales: ${summary.saleCount}';
                              amount = summary.saleReceived + summary.salePending;
                              received = summary.saleReceived;
                              balance = summary.salePending;
                              receivedLabel = 'Received';
                            } else if (selectedTab == 'purchases') {
                              subtitle = 'Purchases: ${summary.purchaseCount}';
                              amount = summary.purchasePaid + summary.purchasePending;
                              received = summary.purchasePaid;
                              balance = summary.purchasePending;
                              receivedLabel = 'Paid';
                            } else if (selectedTab == 'expenses') {
                              subtitle = 'Expenses: ${summary.expenseCount}';
                              amount = summary.expenseAmount;
                              received = summary.expensePaid;
                              balance = summary.expenseBalance;
                              receivedLabel = 'Paid';
                            }

                            return OutputCard(
                              title: title,
                              subtitle: subtitle,
                              amount: amount,
                              received: received,
                              balance: balance,
                              receivedLabel: receivedLabel,
                              isSummaryView: true, // ✅ shared layout with monthly
                              showMenu: false, // hide popup
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