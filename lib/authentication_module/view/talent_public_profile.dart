import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';

class TalentPublicProfileScreen extends StatelessWidget {
  const TalentPublicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,

              child: Column(
                children: [
                  SizedBox(height: kToolbarHeight),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  "https://avatars.githubusercontent.com/u/111274627?v=4" ??
                                      "https://api.dicebear.com/7.x/adventurer/svg?seed=hero",
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.greenAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Aarav Chatterjee",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Actor • Dancer • Performer",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Mumbai, Maharashtra",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------
            // PROFILE INFO
            // -----------------------------------------------------------

            // FOLLOW BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purple]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text("Follow", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // -----------------------------------------------------------
            // STATS
            // -----------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _statBox("1.8K", "Followers"),
                  const SizedBox(width: 10),
                  _statBox("324", "Following"),
                  const SizedBox(width: 10),
                  _statBox("46", "Projects"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // -----------------------------------------------------------
            // ABOUT SECTION
            // -----------------------------------------------------------
            _title("About"),
            _text(
              "A versatile actor trained in theatre and film performance. Experienced "
              "in drama, action, and dance choreography. Worked with multiple production "
              "houses across India.",
            ),

            const SizedBox(height: 20),

            // -----------------------------------------------------------
            // SKILLS
            // -----------------------------------------------------------
            _title("Skills"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _chip("Acting"),
                  _chip("Dance"),
                  _chip("Stage Performance"),
                  _chip("Voice Acting"),
                  _chip("Martial Arts"),
                  _chip("Modeling"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // -----------------------------------------------------------
            // PORTFOLIO GRID
            // -----------------------------------------------------------
            _title("Portfolio"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://picsum.photos/200?random=${index + 1}",
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // -----------------------------------------------------------
            // REVIEWS SECTION
            // -----------------------------------------------------------
            _title("Reviews"),

            _reviewCard(
              name: "Rohit Shetty",
              review:
                  "Fantastic performer! Delivers expressions with great depth. Very professional on set.",
            ),

            _reviewCard(
              name: "Ananya Roy",
              review:
                  "Highly dedicated and creative. Worked with him on an ad film—amazing energy!",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // SMALL COMPONENTS
  // ----------------------------------------------------------------------

  Widget _iconRound(IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _text(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(text, style: const TextStyle(color: Colors.grey, height: 1.4)),
    );
  }

  Widget _chip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(skill, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _reviewCard({required String name, required String review}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage("https://api.dicebear.com/7.x/lorelei/svg?seed=user"),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(review, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
