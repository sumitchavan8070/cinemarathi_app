import 'package:flutter/material.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  int selectedTab = 0;

  final List<String> tabs = ["Connections (142)", "Pending (8)", "Suggestions (24)"];

  // Dummy users
  final List<Map<String, dynamic>> connections = [
    {
      "name": "Arjun Kapoor",
      "role": "Actor & Producer",
      "mutual": "12 mutual connections",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=arjun"
    },
    {
      "name": "Priya Menon",
      "role": "Film Director",
      "mutual": "8 mutual connections",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=priya"
    },
    {
      "name": "Rahul Sharma",
      "role": "Cinematographer",
      "mutual": "15 mutual connections",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=rahul"
    },
    {
      "name": "Ananya Das",
      "role": "Video Editor",
      "mutual": "6 mutual connections",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=ananya"
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

            // -----------------------------------------------------------
            // HEADER
            // -----------------------------------------------------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "My Network",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // -----------------------------------------------------------
            // SEARCH BAR
            // -----------------------------------------------------------
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
                    hintText: "Search connections...",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // -----------------------------------------------------------
            // TOP TABS
            // -----------------------------------------------------------
            SizedBox(
              height: 45,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  bool selected = selectedTab == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedTab = index),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                            colors: [Colors.pinkAccent, Colors.purple])
                            : null,
                        color: selected ? null : Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // -----------------------------------------------------------
            // CONNECTION LIST
            // -----------------------------------------------------------
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: connections.length,
                itemBuilder: (context, index) {
                  final user = connections[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user["avatar"]),
                        ),

                        const SizedBox(width: 14),

                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user["name"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user["role"],
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user["mutual"],
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        // Message Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.message,
                              color: Colors.purpleAccent, size: 22),
                        ),
                      ],
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
