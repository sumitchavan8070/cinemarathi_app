import 'package:flutter/material.dart';

class DiscoverJobsScreen extends StatefulWidget {
  final VoidCallback onTap;

  const DiscoverJobsScreen({super.key, required this.onTap});

  @override
  State<DiscoverJobsScreen> createState() => _DiscoverJobsScreenState();
}

class _DiscoverJobsScreenState extends State<DiscoverJobsScreen> {
  // MAIN CATEGORY TABS
  final List<String> mainTabs = [
    "All Jobs",
    "Auditions",
    "Crew Jobs",
    "Content Creators",
    "Writers",
  ];
  String selectedMainTab = "All Jobs";

  // TAG FILTERS
  final List<String> tags = ["Paid", "Remote", "Urgent", "Featured"];
  List<String> selectedTags = [];

  // JOB LIST DUMMY DATA
  final List<Map<String, dynamic>> jobs = [
    {
      "title": "Lead Actor Required",
      "company": "Red Chillies Entertainment",
      "type": "Full-time",
      "urgent": true,
      "location": "Mumbai, Maharashtra",
      "salary": "₹5L - ₹15L per project",
      "posted": "2 hours ago",
      "logo": "https://api.dicebear.com/7.x/shapes/svg?seed=A",
    },
    {
      "title": "Cinematographer",
      "company": "Dharma Productions",
      "type": "Contract",
      "urgent": false,
      "location": "Delhi, India",
      "salary": "₹10L per project",
      "posted": "1 day ago",
      "logo": "https://api.dicebear.com/7.x/shapes/svg?seed=B",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: widget.onTap,
          child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
        title: Text(
          "Discover Jobs",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF0D0B1A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------------------------------------
            // SEARCH BAR
            // ----------------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,

                        hintText: "Search jobs...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.filter_list, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------------
            // MAIN CATEGORY TABS
            // ----------------------------------------------------------
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: mainTabs.map((tab) {
                  bool selected = tab == selectedMainTab;

                  return GestureDetector(
                    onTap: () => setState(() => selectedMainTab = tab),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(colors: [Colors.pink, Colors.purple])
                            : null,
                        color: selected ? null : Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: selected ? Colors.transparent : Colors.white24),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------------
            // TAG FILTER CHIPS
            // ----------------------------------------------------------
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: tags.map((tag) {
                bool isSelected = selectedTags.contains(tag);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedTags.remove(tag);
                      } else {
                        selectedTags.add(tag);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(colors: [Colors.pink, Colors.purple])
                          : null,
                      color: isSelected ? null : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // ----------------------------------------------------------
            // JOB LIST CARDS
            // ----------------------------------------------------------
            Column(children: jobs.map((job) => _jobCard(job)).toList()),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // JOB CARD WIDGET
  // ---------------------------------------------------------------------------
  Widget _jobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LOGO + TITLE
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white12,
                backgroundImage: NetworkImage(job["logo"]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  job["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.bookmark_border, color: Colors.white70),
            ],
          ),

          const SizedBox(height: 4),
          Text(job["company"], style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 12),

          // TAGS
          Row(
            children: [
              _jobTag(job["type"], Colors.purpleAccent.withOpacity(0.2), Colors.purpleAccent),
              const SizedBox(width: 8),
              if (job["urgent"]) _jobTag("Urgent", Colors.red.withOpacity(0.2), Colors.redAccent),
            ],
          ),

          const SizedBox(height: 12),

          // DESCRIPTION
          Text(
            "Looking for a talented ${job["title"].toLowerCase()} for an exciting project. Experience required.",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 14),

          // LOCATION + SALARY + TIME
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 18),
              Text(job["location"], style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.attach_money, color: Colors.grey, size: 18),
              Text(job["salary"], style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.grey, size: 18),
              Text("Posted ${job["posted"]}", style: const TextStyle(color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 20),

          // BUTTON ROW
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.pink, Colors.purple]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text("Apply Now", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text("Details >", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _jobTag(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
