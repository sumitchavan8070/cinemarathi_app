import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int selectedTab = 0;

  final List<String> tabs = ["All", "Mentions", "System"];

  final List<Map<String, dynamic>> notifications = [
    {
      "name": "Arjun Kapoor",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=arjun",
      "type": "connection_request",
      "message": "sent you a connection request",
      "time": "2m ago",
      "unread": true,
    },
    {
      "name": "Dharma Productions",
      "avatar": "https://api.dicebear.com/7.x/shapes/svg?seed=dharma",
      "type": "job_alert",
      "message": "posted a new job matchingmercials",
      "time": "1h ago",
      "unread": true,
    },
    {
      "name": "System",
      "avatar": "https://api.dicebear.com/7.x/shapes/svg?seed=system",
      "type": "system",
      "message": "Your profile is now 80% complete!",
      "time": "Yesterday",
      "unread": false,
    },
    {
      "name": "Priya Menon",
      "avatar": "https://api.dicebear.com/7.x/adventurer/svg?seed=priya",
      "type": "mention",
      "message": "mentioned you in a comment",
      "time": "2 days ago",
      "unread": false,
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
            // ---------------------------------------------------------
            // HEADER
            // ---------------------------------------------------------
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Notifications",
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
              ),
            ),

            // ---------------------------------------------------------
            // TABS (All / Mentions / System)
            // ---------------------------------------------------------
            SizedBox(
              height: 45,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  bool selected = selectedTab == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedTab = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(colors: [Colors.pink, Colors.purple])
                            : null,
                        color: selected ? null : Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // NOTIFICATION LIST
            // ---------------------------------------------------------
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final n = notifications[index];

                  return _notificationCard(
                    avatar: n["avatar"],
                    name: n["name"],
                    message: n["message"],
                    time: n["time"],
                    type: n["type"],
                    unread: n["unread"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // NOTIFICATION CARD
  // ------------------------------------------------------------------
  Widget _notificationCard({
    required String avatar,
    required String name,
    required String message,
    required String time,
    required String type,
    required bool unread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(unread ? 0.10 : 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(radius: 26, backgroundImage: NetworkImage(avatar)),

          const SizedBox(width: 14),

          // Name + Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME + UNREAD DOT
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.purpleAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                // MESSAGE PREVIEW
                Text(message, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 8),

                // TIME
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),

                // ----------------------------------------------------------
                // ACTION BUTTONS (ONLY for Connection Requests)
                // ----------------------------------------------------------
                if (type == "connection_request") const SizedBox(height: 12),

                if (type == "connection_request")
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Colors.pink, Colors.purple]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Text("Accept", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Text("Reject", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
