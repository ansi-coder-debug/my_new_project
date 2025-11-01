/*
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/application/finance/finance_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
import 'package:my_new_project/widgets/inventory/highlight_reusable_card.dart';
import 'package:my_new_project/widgets/inventory/reusable_info_card.dart';
import 'package:my_new_project/widgets/inventory/reusable_section_card.dart';
import 'package:my_new_project/widgets/inventory/vehicle_info_card.dart';
import 'package:my_new_project/widgets/partnerships/add_partnership_details.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';
import 'package:my_new_project/widgets/sales/profit_summary_card.dart';
import 'package:my_new_project/widgets/sales/sale_form.dart';

class ScreenVehicleDetails extends ConsumerStatefulWidget {
  final String vehicleId;
  final VoidCallback onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScreenVehicleDetails({
    super.key,
    required this.vehicleId,
    required this.onBack,
    this.onEdit,
    this.onDelete,
  });

  @override
  ConsumerState<ScreenVehicleDetails> createState() =>
      _ScreenVehicleDetailsState();
}

class _ScreenVehicleDetailsState extends ConsumerState<ScreenVehicleDetails> {
  String _selectedStatus = "available";

  @override
  void initState() {
    super.initState();

    // ⚠️ DON'T call ref.watch or ref.read for providers that depend on context here
    // So we delay that work to AFTER the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load expenses if not already loaded
      ref.read(expenseProvider.notifier).loadExpenses();

      // Read vehicle and set status
      final vehicleState = ref.read(vehicleProvider);
      final vehicle = vehicleState.vehicles.firstWhere(
        (v) => v.id == widget.vehicleId,
        orElse: () => throw Exception("Vehicle not found"),
      );

      setState(() {
        _selectedStatus = vehicle.status.toLowerCase();
      });
    });
  }

  final List<String> _paymentModes = [
    "Cash",
    "Card",
    "Bank Transfer",
    "Finance",
  ];

  String? _selectedMode;

  void _deletePartnership(Partnership partnership) async {
    final vehicle = ref
        .read(vehicleProvider)
        .vehicles
        .firstWhere((v) => v.id == widget.vehicleId);

    final updatedPartnerships =
        List<Partnership>.from(vehicle.partnerships ?? [])..removeWhere(
          (p) =>
              p.partnerName == partnership.partnerName &&
              p.contribution == partnership.contribution &&
              p.sharePercentage == partnership.sharePercentage,
        );

    final updatedVehicle = vehicle.copyWith(partnerships: updatedPartnerships);

    try {
      await ref.read(vehicleRepositoryProvider).updateVehicle(updatedVehicle);

      // Refresh local state
      await ref.read(vehicleProvider.notifier).loadVehicles();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Partnership deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete partnership')),
      );
    }
  }

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // Dropdown value
  String? _advancePayment;
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehicleProvider);

    // Promote to non-nullable by assigning and returning early
    final vehicle = vehicleState.vehicles.firstWhere(
      (v) => v.id == widget.vehicleId,
    );

    if (vehicle == null) {
      return const Center(child: Text("Vehicle not found"));
    }

    final expenseState = ref.watch(expenseProvider);
    final expenseForThisVehicle = expenseState.expenses
        .where((e) => e.vehicleId.toString() == vehicle.id.toString())
        .toList();

    final totalExpenseAmount = expenseForThisVehicle.fold<double>(
      0.0,
      (sum, e) => sum + e.amount,
    );

    //Finance Details
    final allFinances = ref.watch(financeProvider).finances;
    final vehicleFinances = allFinances
        .where((f) => f.vehicleId == vehicle.id)
        .toList();

    // 🟢 Purchase Info
    final double purchasePrice =
        double.tryParse('${vehicle.purchaseInfo?.price}') ?? 0.0;
    final double purchasePaid =
        double.tryParse('${vehicle.purchaseInfo?.paidAmount}') ?? 0.0;
    final double purchaseBalance = purchasePrice - purchasePaid;
    final double buyingPrice = purchasePrice; //confusion

    // 🟢 Sale Info
    final double salePrice =
        double.tryParse(vehicle.saleInfo?.price ?? '0') ?? 0.0;
    final double saleReceived =
        double.tryParse(vehicle.saleInfo?.receivedPrice ?? '0') ?? 0.0;
    final double financeReceived =
        vehicle.saleInfo?.financeInfo?.receivedPrice ?? 0.0;
    final double totalSaleReceived = saleReceived + financeReceived;
    final double saleBalance = salePrice - totalSaleReceived;

    // 🟢 Grand Total (purchase + expenses)
    final double grandTotal = purchasePrice + totalExpenseAmount;

    // 🟢 Brokerage
    final double totalBrokerage = (vehicle.brokerageInfo ?? []).fold(
      0.0,
      (sum, item) =>
          sum + (double.tryParse(item.amount?.toString() ?? '0') ?? 0.0),
    );

    // 🟢 Profit Calculations
    final double grossProfit = salePrice - grandTotal - totalBrokerage;
    final double partnerProfitShare = 0.0; // set dynamically if needed
    final double ownerProfit = grossProfit - partnerProfitShare;

    return Scaffold(
      body: Column(
        children: [
          // Fixed Header Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),
                KHeight16,
                // Vehicle Title
                Text(
                  "${vehicle.make} ${vehicle.model} (${vehicle.year}) ${vehicle.registrationId}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                KHeight16,
                // Edit + Delete buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Edit button
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(vehicleProvider.notifier)
                              .setVehicleToEdit(vehicle);
                          if (widget.onEdit != null) {
                            widget.onEdit!();
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                    // Delete button
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: widget.onDelete,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Scrollable Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Always show Cost of Acquisition
                  HighlightCard(
                    title: "Total Cost of Acquisition",
                    titleColor: Colors.black,
                    amount: "₹${grandTotal.toStringAsFixed(0)}",
                    amountColor: Colors.blue,
                    breakdown:
                        "(Buying Price: ₹${buyingPrice.toStringAsFixed(0)} + Expenses: ₹${totalExpenseAmount.toStringAsFixed(0)})",
                    breakdownColor: Colors.black,
                    backgroundColor: Colors.white70,
                  ),
                  KHeight,

                  /// 2. Show Purchase Balance if vehicle is not sold
                  if (vehicle.status.toLowerCase() != 'sold' &&
                      purchaseBalance > 0)
                    HighlightCard(
                      title: "Purchase Balance",
                      titleColor: Colors.white,
                      amount: "₹${purchaseBalance.toStringAsFixed(0)}",
                      amountColor: Colors.white,
                      breakdown:
                          "(Total: ₹${purchasePrice.toStringAsFixed(0)} - Paid: ₹${purchasePaid.toStringAsFixed(0)})",
                      breakdownColor: Colors.white,
                      backgroundColor: purchasePaid < purchasePrice
                          ? Colors
                                .red
                                .shade300 // Unpaid → red
                          : Colors.green.shade100, // Fully paid → green
                    ),
                  KHeight,

                  /// 3. If sold, show sale balance and profit
                  if (vehicle.status.toLowerCase() == 'sold') ...[
                    if (saleBalance != 0)
                      HighlightCard(
                        title: "Sale Balance",
                        titleColor: Colors.white,
                        amount: "₹${saleBalance.toStringAsFixed(0)}",
                        amountColor: Colors.white,
                        breakdown:
                            "(Sale Amount: ₹${salePrice.toStringAsFixed(0)} - Received Balance: ₹${totalSaleReceived.toStringAsFixed(0)})",
                        breakdownColor: Colors.white,
                        backgroundColor: totalSaleReceived < salePrice
                            ? Colors
                                  .red
                                  .shade700 // Not fully received → red
                            : Colors.green.shade600, // Fully received → green
                      ),
                    KHeight,

                    HighlightCard(
                      title: grossProfit >= 0 ? "Total Profit" : "Total Loss",
                      titleColor: Colors.white,
                      amount: "₹${grossProfit.toStringAsFixed(0)}",
                      amountColor: Colors.white,
                      breakdown:
                          "(Owner: ₹${ownerProfit.toStringAsFixed(0)} + Partners: ₹${partnerProfitShare.toStringAsFixed(0)})",
                      breakdownColor: Colors.white,
                      backgroundColor: grossProfit >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                  KHeight20,

                  // Vehicle Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 16,
                      child: vehicle.photos.isNotEmpty
                          ? PageView.builder(
                              itemCount: vehicle.photos.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  vehicle.photos[index],
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.network(
                              "https://wallpaperaccess.com/full/472325.jpg",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  KHeight30,

                  // Vehicle Information Section
                  VehicleInfoCard(
                    vehicle: vehicle,
                    selectedStatus: _selectedStatus,
                    onStatusChanged: (newStatus) async {
                      setState(() {
                        _selectedStatus = newStatus;
                      });

                      try {
                        await ref
                            .read(vehicleRepositoryProvider)
                            .updateVehicleStatus(vehicle.id, newStatus);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Status updated to $newStatus"),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to update status"),
                          ),
                        );
                      }
                    },
                  ),
                  KHeight30,

                  // Seller Details Section
                  ReusableInfoCard(
                    title: "Seller Details",
                    dataRows: [
                      MapEntry("Name", vehicle.purchaseInfo.name),
                      MapEntry("Phone", vehicle.purchaseInfo.phone),
                      MapEntry("Address", vehicle.purchaseInfo.address),
                      MapEntry(
                        "Payment Mode",
                        vehicle.purchaseInfo.modeOfPayment,
                      ),
                      MapEntry(
                        "Buying Price",
                        vehicle.purchaseInfo.paidAmount.toString(),
                      ),
                    ],
                  ),
                  KHeight20,

                  ReusableInfoCard(
                    title: "Buyer Details",
                    dataRows: [
                      MapEntry("Name", vehicle.saleInfo?.name ?? ""),
                      MapEntry("Phone", vehicle.saleInfo?.phone ?? ""),
                      MapEntry("Address", vehicle.saleInfo?.address ?? ""),
                      MapEntry(
                        "Sale Price",
                        vehicle.saleInfo?.price?.toString() ?? "",
                      ),
                      MapEntry(
                        "Sale Date",
                        vehicle.saleInfo?.date?.toString() ?? "",
                      ),
                      MapEntry(
                        "Payment Mode",
                        vehicle.saleInfo?.modeOfPayment ?? "",
                      ),
                      MapEntry(
                        "Payment Status",
                        vehicle.saleInfo?.paymentStatus ?? "",
                      ),
                    ],
                  ),
                  KHeight30,

                  // Profit Summary or Sale Form
                  if (vehicle.status.toLowerCase() == "sold") ...[
                    ProfitSummaryCard(
                      vehicle: vehicle,
                      expenses: expenseForThisVehicle,
                    ),
                  ] else if (_selectedStatus == "sold") ...[
                    SaleForm(vehicle: vehicle),
                  ],

                  // Expenses Section
                  ReusableSectionCard(
                    title: "Expenses",
                    isAddEnabled: vehicle.status.toLowerCase() != 'sold',
                    onAddPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AddExpenseDialog(vehicle: vehicle);
                        },
                      );
                    },
                    isEmpty: expenseForThisVehicle.isEmpty,
                    emptyMessage:
                        "No expenses have been recorded for this vehicle.",
                    children: [
                      ...expenseForThisVehicle.map((expense) {
                        final date = DateFormat('d/M/y').format(expense.date);

                        return OutputCard(
                          title:
                              expense.expenseTypeName?.toUpperCase() ??
                              "UNKNOWN",
                          subtitle: "${expense.paymentStatus} - $date",
                          amount: expense.amount,
                          received: expense.expensePaid,
                          receivedLabel: "Paid",
                          showMenu: true,
                          onView: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddExpenseDialog(
                                vehicle: vehicle,
                                expense: expense,
                                isViewOnly: true,
                              ),
                            );
                          },
                          onEdit: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddExpenseDialog(
                                vehicle: vehicle,
                                expense: expense,
                                isViewOnly: false,
                              ),
                            );
                          },
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                  'Are you sure you want to delete this expense?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await ref
                                  .read(expenseProvider.notifier)
                                  .deleteExpense(expense.id!);
                              ref.read(expenseProvider.notifier).loadExpenses();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Expense deleted"),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  KHeight20,

                  // Partnership Section
                  ReusableSectionCard(
                    title: "Partnership",
                    isAddEnabled: vehicle.status.toLowerCase() != 'sold',
                    isEmpty:
                        vehicle.partnerships == null ||
                        vehicle.partnerships!.isEmpty,
                    emptyMessage:
                        "No partnerships have been recorded for this vehicle.",
                    children: vehicle.partnerships != null
                        ? vehicle.partnerships!.map((partnership) {
                            final contribution =
                                double.tryParse(
                                  partnership.contribution ?? '0',
                                ) ??
                                0.0;
                            final received = contribution;

                            // Optional: calculate dynamic label
                            String status;
                            if (received >= contribution && contribution > 0) {
                              status = 'paid';
                            } else if (received > 0 &&
                                received < contribution) {
                              status = 'partial';
                            } else {
                              status = 'pending';
                            }

                            final receivedLabel =
                                status[0].toUpperCase() + status.substring(1);

                            return OutputCard(
                              title:
                                  partnership.partnerName ?? 'Unnamed Partner',
                              subtitle: vehicle.make + ' ' + vehicle.model,
                              amount: contribution,
                              received: received,
                              receivedLabel: receivedLabel,
                              paymentMode: partnership.paymentMode,
                              status: status,
                              showMenu: true,
                              onEdit: () {},
                              onDelete: () {},
                              onView: () {},
                            );
                          }).toList()
                        : [],
                  ),

                  // Finance Details Section (if sold)
                  if (_selectedStatus == "sold") ...[
                    KHeight20,
                    ReusableSectionCard(
                      title: "Finance Details",
                      isEmpty: vehicleFinances.isEmpty,
                      emptyMessage:
                          "No Financial details have been recorded for this vehicle.",
                      children: vehicleFinances.map((finance) {
                        final vehicleName =
                            finance.vehicle?.name ?? 'Unknown Vehicle';
                        final financierName =
                            finance.financier?.companyName ??
                            'Unknown Financier';
                        final amount = finance.amount;
                        final received = finance.receivedPrice;
                        final paymentMode = finance.toAccount ?? 'Unknown';
                        final status = finance.paymentStatus ?? 'Unknown';

                        // Dynamic label logic
                        String receivedLabel;
                        if (received >= amount && amount > 0) {
                          receivedLabel = 'Paid';
                        } else if (received > 0 && received < amount) {
                          receivedLabel = 'Partial';
                        } else {
                          receivedLabel = 'Pending';
                        }

                        return OutputCard(
                          title: vehicleName.toUpperCase(),
                          subtitle: financierName,
                          amount: amount,
                          received: received,
                          balance: amount - received,
                          receivedLabel: receivedLabel,
                          paymentMode: paymentMode,
                          status: status,
                          receivedLabelColor: Colors.green,
                          showBalanceBelowPaid: true,
                          showMenu: true,
                          onView: () {
                            // Optional: show view-only dialog
                          },
                          onEdit: () {
                            // Optional: show edit form
                          },
                          onDelete: () {
                            // Optional: confirm and delete
                          },
                        );
                      }).toList(),
                    ),
                    KHeight30,

                    // Brokerage Details Section
                    ReusableSectionCard(
                      title: "Brokerage",
                      isAddEnabled: vehicle.status.toLowerCase() != 'sold',
                      // Optional: implement onAddPressed
                      isEmpty:
                          vehicle.brokerageInfo == null ||
                          vehicle.brokerageInfo!.isEmpty,
                      emptyMessage:
                          "No brokerage records have been recorded for this vehicle.",
                      children: vehicle.brokerageInfo != null
                          ? vehicle.brokerageInfo!.map((brokerage) {
                              final doubleAmount = brokerage.amount ?? 0.0;
                              final doublePaid = brokerage.brokeragePaid ?? 0.0;
                              final doubleBalance = doubleAmount - doublePaid;

                              // Status calculation
                              String computedStatus;
                              if (doublePaid == 0) {
                                computedStatus = 'pending';
                              } else if (doublePaid < doubleAmount) {
                                computedStatus = 'partial';
                              } else {
                                computedStatus = 'paid';
                              }

                              // Capitalize first letter of label
                              final receivedLabel =
                                  computedStatus[0].toUpperCase() +
                                  computedStatus.substring(1);

                              return OutputCard(
                                title: brokerage.brokerName.toUpperCase(),
                                subtitle: '',
                                amount: doubleAmount,
                                titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                showMenu: true,
                                addTopSubtitleSpacing: false,
                                showBalanceBelowPaid: true,
                                onView: () {
                                  // TODO: Add view logic
                                },
                                onEdit: () {
                                  // TODO: Add edit logic
                                },
                                onDelete: () {
                                  // TODO: Add delete logic
                                },
                              );
                            }).toList()
                          : [],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleImage(String path) {
    if (path.isEmpty) {
      return Center(child: Icon(Icons.car_repair, size: 50));
    }

    if (path.startsWith('http') || path.startsWith('https')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Center(child: Icon(Icons.car_repair, size: 50)),
      );
    } else if (kIsWeb) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Center(child: Icon(Icons.car_repair, size: 50)),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Center(child: Icon(Icons.car_repair, size: 50)),
      );
    }
  }

  // Date format
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _dateFormat.format(picked);
      });
    }
  }
}
*/

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/application/finance/finance_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/core/models/finance.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
import 'package:my_new_project/widgets/inventory/highlight_reusable_card.dart';
import 'package:my_new_project/widgets/inventory/reusable_info_card.dart';
import 'package:my_new_project/widgets/inventory/reusable_section_card.dart';
import 'package:my_new_project/widgets/inventory/vehicle_info_card.dart';
import 'package:my_new_project/widgets/partnerships/add_partnership_details.dart';
import 'package:my_new_project/widgets/partnerships/partnership_dialog.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';
import 'package:my_new_project/widgets/sales/profit_summary_card.dart';
import 'package:my_new_project/widgets/sales/sale_form.dart';
import 'package:my_new_project/widgets/finance/finance_dialog.dart';

// TO GET ACCOUNT NAME
String getAccountNameById(List<Account> accounts, dynamic id) {
  if (id == null) return '';
  final idString = id.toString(); // convert to string
  final match = accounts.firstWhere(
    (a) => a.id.toString() == idString, // convert account ID to string too
    orElse: () => Account(
      id: idString,
      name: 'Account ID: $idString',
      type: '',
      description: '',
    ),
  );
  return match.name;
}

class ScreenVehicleDetails extends ConsumerStatefulWidget {
  final Vehicle vehicle;
  // final String vehicleId;
  final VoidCallback onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScreenVehicleDetails({
    super.key,
    required this.vehicle,
    // required this.vehicleId,
    required this.onBack,
    this.onEdit,
    this.onDelete,
  });

  @override
  ConsumerState<ScreenVehicleDetails> createState() =>
      _ScreenVehicleDetailsState();
}

class _ScreenVehicleDetailsState extends ConsumerState<ScreenVehicleDetails> {
  bool showSaleForm = false;
  Vehicle? vehicleForSale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expenseProvider.notifier).loadExpenses();
      ref.read(financeProvider.notifier).loadFinances();
    });
  }

  // ADD THIS METHOD HERE:
  // void _showSaleForm(BuildContext context, Vehicle vehicle) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         insetPadding: const EdgeInsets.all(20),
  //         child: SaleForm(vehicle: vehicle),
  //       );
  //     },
  //   );
  // }

  void _showSaleForm(Vehicle vehicle) {
    setState(() {
      vehicleForSale = vehicle;
      showSaleForm = true;
    });
  }

  void _deletePartnership(Partnership partnership) async {
    final vehicle = ref
        .read(vehicleProvider)
        .vehicles
        .firstWhere((v) => v.id == widget.vehicle);

    final updatedPartnerships =
        List<Partnership>.from(vehicle.partnerships ?? [])..removeWhere(
          (p) =>
              p.partnerName == partnership.partnerName &&
              p.contribution == partnership.contribution &&
              p.sharePercentage == partnership.sharePercentage,
        );

    final updatedVehicle = vehicle.copyWith(partnerships: updatedPartnerships);

    try {
      await ref.read(vehicleRepositoryProvider).updateVehicle(updatedVehicle);
      await ref.read(vehicleProvider.notifier).loadVehicles();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Partnership deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete partnership')),
      );
    }
  }

  //   final formatCurrency = NumberFormat.currency(
  //   locale: 'en_IN',
  //   symbol: '₹',
  // );

  // Safe currency formatter that handles any input
  String formatCurrency(dynamic value) {
    try {
      if (value == null) return '₹0.00';

      // Convert to double first
      double numericValue;
      if (value is double) {
        numericValue = value;
      } else if (value is int) {
        numericValue = value.toDouble();
      } else if (value is String) {
        numericValue = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
      } else {
        numericValue = 0.0;
      }

      final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
      return formatter.format(numericValue);
    } catch (e) {
      // Fallback if formatting fails
      return '₹${value.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final vehicleState = ref.watch(vehicleProvider);
    final accounts = ref.watch(accountProvider).accounts;
    

    print(
      'Stored ID: ${widget.vehicle.purchaseInfo.modeOfPayment} (${widget.vehicle.purchaseInfo.modeOfPayment.runtimeType})',
    );
    print('Account list IDs: ${accounts.map((a) => a.id).toList()}');
    print(
      "Raw stored payment ID: ${widget.vehicle.purchaseInfo.modeOfPayment}",
    );

    // Convert the stored ID to a readable name
    final paymentModeName = accounts.isNotEmpty
        ? getAccountNameById(
            accounts,
            widget.vehicle.purchaseInfo.modeOfPayment,
          )
        : 'Loading...';

    final salePaymentModeName = accounts.isNotEmpty
        ? getAccountNameById(accounts, widget.vehicle.saleInfo?.modeOfPayment)
        : 'Loading...';

    // final vehicle = widget.vehicle; // ✅ use passed object directly
    // commented out to fetch individual data of brokerage etcc
    // Get UPDATED vehicle data from provider instead of using the initial widget.vehicle
    final updatedVehicle = ref
        .watch(vehicleProvider)
        .vehicles
        .firstWhere(
          (v) => v.id == widget.vehicle.id,
          orElse: () => widget.vehicle, // fallback if not found
        );

    final vehicle = updatedVehicle; // Use the updated vehicle data

    // ========== VEHICLE UPDATE DEBUG ==========
    print('🔄 [VEHICLE UPDATE DEBUG]');
    print('🔄 Original vehicle ID: ${widget.vehicle.id}');
    print('🔄 Updated vehicle ID: ${vehicle.id}');
    print('🔄 Are they same object: ${widget.vehicle == vehicle}');
    print(
      '🔄 Brokerage count in widget.vehicle: ${widget.vehicle.brokerageInfo?.length ?? 0}',
    );
    print(
      '🔄 Brokerage count in updated vehicle: ${vehicle.brokerageInfo?.length ?? 0}',
    );
    // ========== END DEBUG ==========

    final expenseState = ref.watch(expenseProvider);
    final expenseForThisVehicle = expenseState.expenses
        .where((e) => e.vehicleId.toString() == vehicle.id.toString())
        .toList();

    // Finance Details
    final allFinances = ref.watch(financeProvider).finances;
    final vehicleFinances = allFinances
        .where((f) => f.vehicleId == vehicle.id)
        .toList();


    // Add this RIGHT BEFORE your purchase calculations:
    print('🔍 [DEBUG] Vehicle purchaseInfo: ${vehicle.purchaseInfo}');
    print('🔍 [DEBUG] purchaseInfo.price: ${vehicle.purchaseInfo.price}');
    print(
      '🔍 [DEBUG] purchaseInfo.price runtimeType: ${vehicle.purchaseInfo.price.runtimeType}',
    );
    print('🔍 [DEBUG] purchaseInfo.toJson(): ${vehicle.purchaseInfo.toJson()}');

    // ========== PURCHASE CALCULATIONS (CORRECTED) ==========
    // Use purchase_paid instead of purchase_price
    final double purchasePrice =
        vehicle.purchaseInfo.paidAmount; // This is 70000
    final double purchasePaidDirectly = vehicle.purchaseInfo.paidAmount;

    // Partner contributions
    final double totalPartnerContributionPaid = (vehicle.partnerships ?? [])
        .fold(
          0.0,
          (sum, p) => sum + (double.tryParse(p.contributionPaid ?? '0') ?? 0.0),
        );

    final double totalPurchasePaid =
        purchasePaidDirectly + totalPartnerContributionPaid;
    final double purchaseBalance = purchasePrice - totalPurchasePaid;

    // ========== SALE CALCULATIONS ==========
    final double salePrice =
        double.tryParse(vehicle.saleInfo?.price ?? '0') ?? 0.0;
    final double saleReceivedDirectly =
        double.tryParse(vehicle.saleInfo?.receivedPrice ?? '0') ?? 0.0;
    final double saleReceivedFromFinance =
        vehicle.saleInfo?.financeInfo?.receivedPrice ?? 0.0;
    final double totalSaleReceived =
        saleReceivedDirectly + saleReceivedFromFinance;
    final double saleBalance = salePrice - totalSaleReceived;

    // ========== EXPENSE CALCULATION ==========
    final double totalExpenseAmount = expenseForThisVehicle.fold<double>(
      0.0,
      (sum, e) => sum + e.amount,
    );

    // ========== BROKERAGE DEBUG ==========
    print('🔍 [BROKERAGE DEBUG] Checking brokerage data...');
    print('🔍 brokerageInfo exists: ${vehicle.brokerageInfo != null}');
    print('🔍 brokerageInfo length: ${vehicle.brokerageInfo?.length ?? 0}');

    if (vehicle.brokerageInfo != null && vehicle.brokerageInfo!.isNotEmpty) {
      print('💰 Brokerage details:');
      vehicle.brokerageInfo!.forEach((brokerage) {
        print('   - Broker: ${brokerage.brokerName}');
        print('     Amount: ${brokerage.amount}');
        print('     Paid: ${brokerage.brokeragePaid}');
        print('     Status: ${brokerage.paymentStatus}');
        print('     Amount runtimeType: ${brokerage.amount.runtimeType}');
      });
    } else {
      print('❌ No brokerage data found!');
    }
    // ========== END BROKERAGE DEBUG ==========
    // ========== BROKERAGE CALCULATION ==========
    final double totalBrokerage = (vehicle.brokerageInfo ?? []).fold(
      0.0,
      (sum, item) => sum + (item.amount ?? 0.0),
    );

    // ========== PROFIT CALCULATIONS ==========
    // Total Cost of Acquisition (Matches React: buyingPrice + totalExpenses)
    final double grandTotal =
        purchasePrice + totalExpenseAmount; // Now 70000 + 0 = 70000

    // Total Cost (Matches React: grandTotal + totalBrokerage)
    final double totalCost =
        grandTotal + totalBrokerage; // Now 70000 + 0 = 70000

    // Gross Profit (Matches React: salePrice - totalCost)
    final double grossProfit =
        salePrice - totalCost; // Now 150000 - 70000 = 80000

    // Partner Profit Share
    final double totalPartnerProfitShare = (vehicle.partnerships ?? []).fold(
      0.0,
      (sum, p) {
        final profitShare = double.tryParse(p.sharePercentage ?? '0') ?? 0.0;
        return sum + profitShare;
      },
    );

    // Owner Profit
    final double ownerProfit =
        grossProfit - totalPartnerProfitShare; // Now 80000 - 0 = 80000

    // In your main screen build method, after all calculations:
    print('🎯 [MAIN SCREEN] Calculations:');
    print('🎯 Purchase Price: $purchasePrice');
    print('🎯 Sale Price: $salePrice');
    print('🎯 Total Expenses: $totalExpenseAmount');
    print('🎯 Total Brokerage: $totalBrokerage');
    print('🎯 Grand Total: $grandTotal');
    print('🎯 Total Cost: $totalCost');
    print('🎯 Gross Profit: $grossProfit');
    print('🎯 Partner Profit Share: $totalPartnerProfitShare');
    print('🎯 Owner Profit: $ownerProfit');

    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed Header Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        " ${vehicle.model}  (${vehicle.registrationId})",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                KHeight16,
                // Edit + Delete buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Edit button
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(vehicleProvider.notifier)
                              .setVehicleToEdit(vehicle);
                          if (widget.onEdit != null) {
                            widget.onEdit!();
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                    // Delete button
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                      IconButton(
  icon: const Icon(Icons.delete),
  onPressed: () {
    _showDeleteDialog(context, vehicle.id,ref);
  },
),

                   
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Always show Cost of Acquisition
                  // 1. Always show Cost of Acquisition
                  HighlightCard(
                    title: "Total Cost of Acquisition",
                    titleColor: Colors.black,
                    amount: formatCurrency(grandTotal),
                    amountColor: Colors.blue,
                    breakdown:
                        "(Buying Price: ₹${formatCurrency(purchasePrice)} + Expenses: ₹${formatCurrency(totalExpenseAmount)})",
                    breakdownColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                  KHeight,

                  /// 2. Show Purchase Balance if vehicle is not sold
                  if (vehicle.status.toLowerCase() != 'sold' &&
                      purchaseBalance > 0)
                    HighlightCard(
                      title: "Purchase Balance",
                      titleColor: Colors.white,
                      amount: "₹${formatCurrency(purchaseBalance)}",
                      amountColor: Colors.white,
                      breakdown:
                          "(Total: ₹${formatCurrency(purchasePrice)} - Paid: ₹${formatCurrency(totalPurchasePaid)})",
                      breakdownColor: Colors.white,
                      backgroundColor: purchaseBalance > 0
                          ? Colors.red
                          : Colors.green,
                    ),
                  KHeight,

                  /// 3. If sold, show sale balance and profit
                  if (vehicle.status.toLowerCase() == 'sold') ...[
                    if (saleBalance != 0)
                      HighlightCard(
                        title: "Sale Balance",
                        titleColor: Colors.white,
                        amount: "₹${formatCurrency(saleBalance)}",
                        amountColor: Colors.white,
                        breakdown:
                            "(Sale Amount: ₹${formatCurrency(salePrice)} - Received: ₹${formatCurrency(totalSaleReceived)})",
                        breakdownColor: Colors.white,
                        backgroundColor: saleBalance > 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    KHeight,

                    HighlightCard(
                      title: grossProfit >= 0 ? "Total Profit" : "Total Loss",
                      titleColor: Colors.white,
                      amount: "₹${formatCurrency(grossProfit)}",
                      amountColor: Colors.white,
                      breakdown:
                          "(Owner: ₹${formatCurrency(ownerProfit)} + Partners: ₹${formatCurrency(totalPartnerProfitShare)})",
                      breakdownColor: Colors.white,
                      backgroundColor: grossProfit >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                  KHeight20,

                  // Vehicle Image with Swiper
                  _buildVehicleImageSection(vehicle),
                  KHeight30,



               

// if (vehicleState.showSaleForm && vehicleState.vehicleToSell != null)
//   Container(
//     padding: const EdgeInsets.all(16),
//     margin: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: Colors.grey),
//       color: Colors.white,
//     ),
//     child: SaleForm(
//       vehicle: vehicleState.vehicleToSell!,
     
//       onSubmitSuccess: () {
//         ref.read(vehicleProvider.notifier).hideSaleForm();
//         ref.read(vehicleProvider.notifier).loadVehicles();
//       },
//     ),
//   ),
if (vehicleState.showSaleForm && vehicleState.vehicleToSell != null)
  ReusableInfoCard(
    title: "Sales Information",
    dataRows: const [], // no display rows in top part
    child: SaleForm(
      vehicle: vehicleState.vehicleToSell!,
      onSubmitSuccess: () {
        ref.read(vehicleProvider.notifier).hideSaleForm();
        ref.read(vehicleProvider.notifier).loadVehicles();
      },
    ),
  ),



                  VehicleInfoCard(
                    vehicle: vehicle,
                    onStatusChanged: (newStatus) async {
                      // if (newStatus == "sold") {
                      //   _showSaleForm(context, vehicle);
                      //   return;
                      // }

                      if (newStatus == "sold") {
  ref.read(vehicleProvider.notifier).showSaleForm(vehicle);
  return;
}


                      try {
                        await ref
                            .read(vehicleRepositoryProvider)
                            .updateVehicleStatus(vehicle.id, newStatus);
                        ref.read(vehicleProvider.notifier).loadVehicles();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Status updated to $newStatus"),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to update status"),
                          ),
                        );
                      }
                    },
                    isStatusLoading: false,
                  ),
                  KHeight30,

                  // Seller Details Section
                  ReusableInfoCard(
                    title: "Seller Details",
                    dataRows: [
                      MapEntry("Name", vehicle.purchaseInfo.name),
                      MapEntry("Phone", vehicle.purchaseInfo.phone),
                      MapEntry("Address", vehicle.purchaseInfo.address),
                      MapEntry("Payment Mode", paymentModeName),
                      MapEntry(
                        "Buying Price",
                        formatCurrency(vehicle.purchaseInfo.paidAmount),
                      ),
                    ],
                  ),
                  KHeight20,

                  if (vehicle.status.toLowerCase() == 'sold')
                    ReusableInfoCard(
                      title: "Buyer Details",
                      dataRows: [
                        MapEntry("Name", vehicle.saleInfo?.name ?? ""),
                        MapEntry("Phone", vehicle.saleInfo?.phone ?? ""),
                        MapEntry("Address", vehicle.saleInfo?.address ?? ""),
                        MapEntry(
                          "Sale Price",
                          vehicle.saleInfo?.price != null
                              ? formatCurrency(vehicle.saleInfo!.price)
                              : "",
                        ),

                        MapEntry(
                          "Sale Date",
                          vehicle.saleInfo?.date?.toString() ?? "",
                        ),
                        MapEntry("Payment Mode", salePaymentModeName),
                        MapEntry(
                          "Payment Status",
                          vehicle.saleInfo?.paymentStatus ?? "",
                        ),
                      ],
                    ),
                  KHeight30,

                  // Profit Summary or Sale Form
                  if (vehicle.status.toLowerCase() == "sold") ...[
                    ProfitSummaryCard(
                      vehicle: vehicle,
                      expenses: expenseForThisVehicle,
                      totalBrokerage: totalBrokerage,
                    ),
                  ],

                  // Expenses Section
                  ReusableSectionCard(
                    title: "Expenses",
                    isAddEnabled: vehicle.status.toLowerCase() != 'sold',
                    onAddPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AddExpenseDialog(vehicle: vehicle);
                        },
                      );
                    },
                    isEmpty: expenseForThisVehicle.isEmpty,
                    emptyMessage:
                        "No expenses have been recorded for this vehicle.",
                    children: [
                      ...expenseForThisVehicle.map((expense) {
                        final date = DateFormat('d/M/y').format(expense.date);

                        return OutputCard(
                          title:
                              expense.expenseTypeName?.toUpperCase() ??
                              "UNKNOWN",
                          subtitle: "${expense.paymentStatus} - $date",
                          amount: expense.amount,
                          received: expense.expensePaid,
                          receivedLabel: "Paid",
                          showMenu: true,
                          onView: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddExpenseDialog(
                                vehicle: vehicle,
                                expense: expense,
                                isViewOnly: true,
                              ),
                            );
                          },
                          onEdit: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddExpenseDialog(
                                vehicle: vehicle,
                                expense: expense,
                                isViewOnly: false,
                              ),
                            );
                          },
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                  'Are you sure you want to delete this expense?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await ref
                                  .read(expenseProvider.notifier)
                                  .deleteExpense(expense.id!);
                              ref.read(expenseProvider.notifier).loadExpenses();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Expense deleted"),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  KHeight20,

                  // Partnership Section
                  if (vehicle.partnerships != null &&
                      vehicle.partnerships!.isNotEmpty) // dont show dialog
                    ReusableSectionCard(
                      title: "Partnership",
                      isAddEnabled: vehicle.status.toLowerCase() != 'sold',
                      isEmpty:
                          vehicle.partnerships == null ||
                          vehicle.partnerships!.isEmpty,
                      emptyMessage:
                          "No partnerships have been recorded for this vehicle.",
                      children: vehicle.partnerships != null
                          ? vehicle.partnerships!.map((partnership) {
                              final contribution =
                                  double.tryParse(
                                    partnership.contribution ?? '0',
                                  ) ??
                                  0.0;
                              final received = contribution;

                              // Optional: calculate dynamic label
                              String status;
                              if (received >= contribution &&
                                  contribution > 0) {
                                status = 'paid';
                              } else if (received > 0 &&
                                  received < contribution) {
                                status = 'partial';
                              } else {
                                status = 'pending';
                              }

                              final receivedLabel =
                                  status[0].toUpperCase() + status.substring(1);

                              return OutputCard(
                                title:
                                    partnership.partnerName ??
                                    'Unnamed Partner',
                                subtitle: vehicle.make + ' ' + vehicle.model,
                                amount: contribution,
                                received: received,
                                receivedLabel: receivedLabel,
                                paymentMode: partnership.paymentMode,
                                status: status,
                                showMenu: true,
                                onEdit: () {},
                                onDelete: () {},
                                onView: () {},
                              );
                            }).toList()
                          : [],
                    ),

                  // ✅ Finance Details Section (ONLY show if vehicle is actually sold)
                  // Finance Details Section (show if vehicle is actually sold) - CHANGED CONDITION
                  if (vehicle.status.toLowerCase() == 'sold') ...[
                    KHeight20,
                    ReusableSectionCard(
                      title: "Finance Details",
                      isEmpty: vehicleFinances.isEmpty,
                      emptyMessage:
                          "No Financial details have been recorded for this vehicle.",
                      children: vehicleFinances.map((finance) {
                        final vehicleName =
                            finance.vehicle?.name ?? 'Unknown Vehicle';
                        final financierName =
                            finance.financier?.companyName ??
                            'Unknown Financier';
                        final amount = finance.amount;
                        final received = finance.receivedPrice;
                        final paymentMode = finance.toAccount ?? 'Unknown';
                        final status = finance.paymentStatus ?? 'Unknown';

                        // Dynamic label logic
                        String receivedLabel;
                        if (received >= amount && amount > 0) {
                          receivedLabel = 'Paid';
                        } else if (received > 0 && received < amount) {
                          receivedLabel = 'Partial';
                        } else {
                          receivedLabel = 'Pending';
                        }

                        return OutputCard(
                          title: vehicleName.toUpperCase(),
                          subtitle: financierName,
                          amount: amount,
                          received: received,
                          balance: amount - received,
                          receivedLabel: receivedLabel,
                          paymentMode: paymentMode,
                          status: status,
                          receivedLabelColor: Colors.green,
                          showBalanceBelowPaid: true,
                          showMenu: true,
                          onView: () {
                            // Optional: show view-only dialog
                          },
                          onEdit: () {
                            // Optional: show edit form
                          },
                          onDelete: () {
                            // Optional: confirm and delete
                          },
                        );
                      }).toList(),
                    ),
                    KHeight30,
                  ],

                  // Brokerage Details Section (show if vehicle is actually sold and has brokerage) - CHANGED CONDITION & ADDED SUBTITLE
                  if (vehicle.status.toLowerCase() == 'sold' &&
                      vehicle.brokerageInfo != null &&
                      vehicle.brokerageInfo!.isNotEmpty) ...[
                    KHeight20,
                    ReusableSectionCard(
                      title: "Brokerage",
                      isAddEnabled: vehicle.status.toLowerCase() != 'sold',
                      isEmpty:
                          false, // CHANGED: Always false since we check condition above
                      emptyMessage:
                          "", // CHANGED: Empty since we only show when data exists
                      children: vehicle.brokerageInfo!.map((brokerage) {
                        final doubleAmount = brokerage.amount ?? 0.0;
                        final doublePaid = brokerage.brokeragePaid ?? 0.0;
                        final doubleBalance = doubleAmount - doublePaid;

                        // Status calculation
                        String computedStatus;
                        if (doublePaid == 0) {
                          computedStatus = 'pending';
                        } else if (doublePaid < doubleAmount) {
                          computedStatus = 'partial';
                        } else {
                          computedStatus = 'paid';
                        }

                        // Capitalize first letter of label
                        final receivedLabel =
                            computedStatus[0].toUpperCase() +
                            computedStatus.substring(1);

                        return OutputCard(
                          title: brokerage.brokerName.toUpperCase(),
                          subtitle: brokerage.remarks?.isNotEmpty == true
                              ? brokerage.remarks!
                              : '', // ADDED: Show remarks as subtitle
                          amount: doubleAmount,
                          received: doublePaid, // ADDED: Show paid amount
                          balance: doubleBalance, // ADDED: Show balance
                          receivedLabel:
                              receivedLabel, // ADDED: Show status label
                          paymentMode:
                              brokerage.paymentStatus ??
                              '', // ADDED: Show payment mode
                          status: computedStatus, // ADDED: Show status
                          receivedLabelColor: Colors.green,
                          showBalanceBelowPaid:
                              true, // ADDED: Show balance below paid
                          showMenu: true,
                          addTopSubtitleSpacing: false,
                          onView: () {
                            // TODO: Add view logic
                          },
                          onEdit: () {
                            // TODO: Add edit logic
                          },
                          onDelete: () {
                            // TODO: Add delete logic
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleImageSection(vehicle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 16,
        child: vehicle.photos.isNotEmpty
            ? PageView.builder(
                itemCount: vehicle.photos.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    vehicle.photos[index],
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.network(
                "https://placehold.co/600x400/e2e8f0/475569?text=No+Image+Available",
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  // delete

void _showDeleteDialog(BuildContext context, String vehicleId, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Confirm Delete",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Are you sure you want to delete?",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        backgroundColor: Colors.grey.shade200,
                        side: BorderSide.none, // Remove border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final notifier = ref.read(vehicleProvider.notifier);
                        await notifier.deleteVehicle(vehicleId);
                   
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Close details page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Confirm button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

}
