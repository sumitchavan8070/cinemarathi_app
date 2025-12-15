import 'package:flutter/material.dart';

class PlansScreen extends StatelessWidget {
  PlansScreen({super.key});

  // Dummy data (replace with API)
  final List<Map<String, dynamic>> plans = [
    {
      "id": 1,
      "name": "Monthly",
      "price": "199.00",
      "duration_days": 30,
      "features": "Verified Badge, Profile Boost, Priority Casting",
    },
    {
      "id": 2,
      "name": "Quarterly Premium",
      "price": "499.00",
      "duration_days": 90,
      "features": "Verified Badge, Boost, Unlimited Applications",
    },
    {
      "id": 3,
      "name": "Yearly Premium",
      "price": "999.00",
      "duration_days": 365,
      "features": "All Premium Features + Featured Profile Placement",
    },
    {
      "id": 4,
      "name": "Profile Boost Pack",
      "price": "149.00",
      "duration_days": 15,
      "features": "Boost listing visibility for 15 days",
    },
    {
      "id": 5,
      "name": "Job Posting Pack",
      "price": "299.00",
      "duration_days": 30,
      "features": "Allows production houses to post up to 5 jobs",
    },
    {
      "id": 6,
      "name": "Free Plan",
      "price": "0.00",
      "duration_days": null,
      "features": "Basic Profile, Limited Applications, No Boost, No Badge",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: plans.length,
        itemBuilder: (context, i) {
          final p = plans[i];

          return PlanCard(
            name: p["name"],
            price: p["price"],
            durationDays: p["duration_days"],
            features: p["features"],
          );
        },
      ),
    );
  }

  // -------------------------------------------------------
  // COLOR SELECTION BASED ON PLAN NAME
  // -------------------------------------------------------

  // -------------------------------------------------------
  // PLAN CARD
  // -------------------------------------------------------
}

class PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final dynamic durationDays;
  final String features;

  const PlanCard({
    super.key,
    required this.name,
    required this.price,
    this.durationDays,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    bool isFree = price == "0.00";

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: _getGradient(name),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 6),

          // PRICE + DURATION
          Row(
            children: [
              Text(
                isFree ? "Free" : "₹$price",
                style: TextStyle(
                  color: isFree ? Colors.greenAccent : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              if (durationDays != null)
                Text("$durationDays days", style: const TextStyle(color: Colors.white70)),
            ],
          ),

          const SizedBox(height: 14),

          // FEATURES
          Flexible(
            child: Text(
              features,
              style: const TextStyle(color: Colors.white70, height: 1.4, fontSize: 14),
            ),
          ),

          const SizedBox(height: 18),

          // BUTTON
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                isFree ? "Your Current Plan" : "Subscribe Now",
                style: TextStyle(
                  color: isFree ? Colors.greenAccent : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradient(String name) {
    if (name.contains("Monthly")) {
      return const LinearGradient(colors: [Colors.pinkAccent, Colors.purple]);
    } else if (name.contains("Quarterly")) {
      return const LinearGradient(colors: [Colors.deepPurple, Colors.blueAccent]);
    } else if (name.contains("Yearly")) {
      return const LinearGradient(colors: [Color(0xFFFFD700), Colors.orange]);
    } else if (name.contains("Boost")) {
      return const LinearGradient(colors: [Colors.teal, Colors.green]);
    } else if (name.contains("Job")) {
      return const LinearGradient(colors: [Colors.blue, Colors.indigo]);
    } else if (name.contains("Free")) {
      return LinearGradient(colors: [Colors.grey.shade900, Colors.grey.shade800]);
    }

    // Default color if unmatched
    return const LinearGradient(colors: [Colors.pink, Colors.purple]);
  }
}
