import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/constants/constant.dart';

class ScreenSubscription extends ConsumerStatefulWidget {
  const ScreenSubscription({super.key});

  @override
  ConsumerState<ScreenSubscription> createState() => _ScreenSubscriptionState();
}

class _ScreenSubscriptionState extends ConsumerState<ScreenSubscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Subscription Plans'),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Save 20% Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Save 20%',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),

                // Premium label
                const Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      'Premium',
                      style: TextStyle(fontWeight: FontWeight.bold,
                       color: Colors.grey
                       ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Starter Plan title
                const Text(
                  'Starter',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black
                  ),
                ),

                const SizedBox(height: 4),

                // Price
                const Text(
                  '₹1,999 / month',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold
                  ,color: Colors.black),
                ),

                const SizedBox(height: 4),

                // Description
                const Text(
                  'Ideal for small dealerships.',
                  style: TextStyle(color: Colors.black),
                ),

               KHeight16,

                const Divider(),

                KHeight16,

                // Features
                const FeatureRow(text: 'Up to 50 vehicle listings'),
                const FeatureRow(text: 'Basic sales & expense tracking'),
                const FeatureRow(text: '1 user account'),
                const FeatureRow(text: 'Email support'),

                const SizedBox(height: 20),

                // Buttons
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
                    onPressed: () {
                      // You can use `ref.read(...)` here
                    },
                    child: const Text(
                      'Choose Plan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                      color: Colors.white
                      ),
                      
                    ),
                  ),
                ),

                const SizedBox(height: 12),

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
                    onPressed: () {},
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

                const SizedBox(height: 12),

                // Terms & Conditions
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  final String text;
  const FeatureRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.black),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(
            fontSize: 14,
            color: Colors.black
          )
          ),
        ],
      ),
    );
  }
}
