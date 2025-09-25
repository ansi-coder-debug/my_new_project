import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_subscription.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final String badgeText;
  final String planLabel;
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final VoidCallback onSelect;
  final VoidCallback onLearnMore;

  const SubscriptionPlanCard({
    super.key,
    required this.badgeText,
    required this.planLabel,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.onSelect,
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            KHeight16,

            // Label (e.g. Premium)
            Row(
              children: [
                const Icon(Icons.circle, size: 12, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  planLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ],
            ),
           KHeight,

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
           Kheight6,

            // Price
            Text(
              price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),

            // Description
            Text(
              description,
              style: const TextStyle(color: Colors.black),
            ),
           KHeight16,
            const Divider(),
            KHeight16,

            // Features List
            ...features.map((f) => FeatureRow(text: f)).toList(),

           KHeight16,
            // Choose Plan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: onSelect,
                child: const Text(
                  'Choose Plan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
           KHeight16,

            // Learn More Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: onLearnMore,
                child: const Text(
                  'Learn More',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            KHeight16,

            // Terms
            const Center(
              child: Text.rich(
                TextSpan(
                  text: 'Billed monthly. ',
                  children: [
                    TextSpan(
                      text: 'Terms and conditions apply.',
                      style: TextStyle(decoration: TextDecoration.underline),
                    )
                  ],
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
