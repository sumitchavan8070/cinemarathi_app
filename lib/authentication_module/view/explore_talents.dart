import 'package:flutter/material.dart';

class ExploreTalentsScreen extends StatefulWidget {
  const ExploreTalentsScreen({super.key});

  @override
  State<ExploreTalentsScreen> createState() => _ExploreTalentsScreenState();
}

class _ExploreTalentsScreenState extends State<ExploreTalentsScreen> {
  final List<String> categories = [
    "Actors",
    "Models",
    "Directors",
    "Editors",
    "Cinematographers",
    "Writers",
    "Dancers",
  ];

  int selectedCategory = 0;

  final List<Map<String, dynamic>> talents = [
    {
      "name": "Aarav Singh",
      "role": "Actor",
      "location": "Mumbai",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=aarav",
      "rating": 4.8,
      "experience": "5 yrs",
    },
    {
      "name": "Riya Malhotra",
      "role": "Model",
      "location": "Delhi",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=riya",
      "rating": 4.6,
      "experience": "3 yrs",
    },
    {
      "name": "Kabir Verma",
      "role": "Director",
      "location": "Pune",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=kabir",
      "rating": 4.9,
      "experience": "8 yrs",
    },
    {
      "name": "Sara Khan",
      "role": "Dancer",
      "location": "Bengaluru",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=sara",
      "rating": 4.7,
      "experience": "6 yrs",
    },
    {
      "name": "Omkar Patil",
      "role": "Cinematographer",
      "location": "Mumbai",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=omkar",
      "rating": 4.8,
      "experience": "7 yrs",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------------------------------------------
            // HEADER
            // ----------------------------------------------------------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Explore Talents",
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
              ),
            ),

            // ----------------------------------------------------------------
            // SEARCH BAR
            // ----------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    icon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    hintText: "Search talents...",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------------------------------------------------
            // CATEGORY CHIPS
            // ----------------------------------------------------------------
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool selected = selectedCategory == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(colors: [Colors.pink, Colors.purple])
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        color: selected ? null : Colors.white.withOpacity(0.07),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------------------
            // TALENT GRID
            // ----------------------------------------------------------------
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: talents.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final t = talents[index];

                  return GestureDetector(
                    onTap: () {
                      // Navigate to profile
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 14),

                          // Avatar
                          CircleAvatar(radius: 40, backgroundImage: NetworkImage(t["avatar"])),

                          const SizedBox(height: 10),

                          // Name
                          Text(
                            t["name"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          // Role
                          Text(t["role"], style: const TextStyle(color: Colors.grey, fontSize: 13)),

                          const SizedBox(height: 6),

                          // Location
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                t["location"],
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // FOLLOW BUTTON
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 14),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.pink, Colors.purple]),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "Follow",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
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
