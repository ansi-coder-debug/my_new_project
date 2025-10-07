import 'package:flutter/material.dart';

class OutputCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? phone;
  final double? amount;
  final double? received;
  final double? balance;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showMenu;
  final String receivedLabel;
  final Color? receivedLabelColor; // <-- NEW param here
  final String? status;
  // Controls:
  final bool showAmount; // Show or hide amount section
  final TextStyle? titleStyle; // Override title text style
  final TextStyle? subtitleStyle; // Override subtitle text style
  // cashbook
  final Color? amountColor;
  final String? amountPrefix;
  final bool isCashBook;
  //brokerage
  final bool addTopSubtitleSpacing; // NEW
  final bool showBalanceBelowPaid; // NEW: layout override
  //finance
  final String? paymentMode; // <-- Add this line here
  //advance
  final String? date;
  //broker
  final String? address;
  //summary
  final bool isSummaryView;

  const OutputCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.amount,
    this.phone,
    this.received,
    this.balance,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.showMenu = true,
    this.receivedLabel = 'Received',
    this.receivedLabelColor,
    this.status,
    //controls
    this.showAmount = true, // default: show amount section
    this.titleStyle,
    this.subtitleStyle,
    this.amountColor,
    this.amountPrefix,
    this.isCashBook = false,
    this.addTopSubtitleSpacing = true,
    this.showBalanceBelowPaid = false,
    this.paymentMode,
    this.date,
    this.address,
    this.isSummaryView = false, // <-- Add this with default false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content with padding
        Padding(
          padding: const EdgeInsets.only(right: 40), // space for popup
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            onTap: onView,
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                if (showAmount && amount != null)
                  if (!isCashBook)
                    Text(
                      "₹${amount!.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  else
                    Text(
                      "${amount! >= 0 ? '+' : '-'}₹${amount!.abs().toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: amount! >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
              ],
            ),

            subtitle: isSummaryView
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ✅ Left Side (Expenses)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subtitle, // e.g. "Expenses: 3"
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        // ✅ Right Side (Paid & Balance stacked vertically)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Paid: ₹${received?.toStringAsFixed(2) ?? '0.00'}',
                              style: const TextStyle(color: Colors.green),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Balance: ₹${balance?.toStringAsFixed(2) ?? '0.00'}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                //monthly summarry
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (addTopSubtitleSpacing) const SizedBox(height: 4),

                      /// Line 1: Vehicle make + Paid
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subtitle,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),

                          if (showAmount &&
                              received != null &&
                              receivedLabel.isNotEmpty)
                            Text(
                              "$receivedLabel: ${received!.toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.green),
                            ),
                        ],
                      ),

                      if (date != null && date!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            date!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                      if (address != null && address!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            address!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                      // This widget will only show if paymentMode is provided (non-null & non-empty)finance
                      if (paymentMode != null && paymentMode!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Paid via: $paymentMode",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                      /// NEW: Balance below paid if flag is set cashbook
                      if (balance != null &&
                          balance! > 0 &&
                          showBalanceBelowPaid)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Balance: ₹${balance!.toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),

                      // Only add vertical space if phone or status exists (avoid gap)
                      if ((phone != null && phone!.isNotEmpty) ||
                          (status != null && status!.isNotEmpty))
                        const SizedBox(height: 4),

                      // const SizedBox(height: 4),
                      if (phone != null && phone!.isNotEmpty)
                        Row(
                          children: [
                            if (phone != null && phone!.isNotEmpty)
                              Expanded(
                                child: Text(
                                  phone!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            if (balance != null &&
                                balance! > 0 &&
                                !showBalanceBelowPaid)
                              Text(
                                "Balance: ₹${balance!.toStringAsFixed(2)}",
                                style: const TextStyle(color: Colors.red),
                              ),
                          ],
                        ),

                      if (status != null && status!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Status: $status",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ), //hrrrrrrrrrrrrrrrrrrrrrrrrr
                    ],
                  ),
          ),
        ),

        // Popup menu positioned independently to the top right
        if (showMenu) Positioned(top: 24, right: 8, child: _buildPopupMenu()),

        const Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: Divider(height: 0),
        ),
      ],
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'view':
            onView?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },

      // You can add offset to position it better (optional)
      offset: Offset(0, 60),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      itemBuilder: (context) => [
        if (onView != null)
          PopupMenuItem<String>(
            value: 'view',
            child: _buildCustomMenuItem(
              icon: Icons.remove_red_eye_outlined,
              iconColor: Colors.blue,
              text: "View",
            ),
          ),

        if (onEdit != null)
          PopupMenuItem<String>(
            value: 'edit',
            child: _buildCustomMenuItem(
              icon: Icons.edit_square,
              iconColor: Colors.black,
              text: "Edit",
            ),
          ),
        if (onDelete != null)
          PopupMenuItem<String>(
            value: 'delete',
            child: _buildCustomMenuItem(
              icon: Icons.delete,
              iconColor: Colors.red,
              text: 'Delete',
            ),
          ),
      ],
    );
  }

  // 👇 Custom method to build each menu item as you like
  Widget _buildCustomMenuItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      width: 100, // Customize width
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 16), // 👈 space between icon and text
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
