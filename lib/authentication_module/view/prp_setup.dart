import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/components/core_messenger.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';

class ProfileSetup extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;

  const ProfileSetup({
    super.key,
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final PageController _pageController = PageController();
  int currentStep = 0;

  // ---------------------------
  // Controllers (IMPORTANT)
  // ---------------------------
  late TextEditingController fullNameCtrl;
  late TextEditingController professionCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController contactCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController portfolioCtrl;
  late TextEditingController instagramCtrl;
  late TextEditingController youtubeCtrl;
  final TextEditingController skillCtrl = TextEditingController();

  // ---------------------------
  // Other State
  // ---------------------------
  String gender = "male";
  String dob = "";
  String availability = "Available";
  String userType = "actor";
  List<String> skills = [];

  // ---------------------------
  // INIT
  // ---------------------------
  @override
  void initState() {
    super.initState();

    fullNameCtrl = TextEditingController(text: widget.fullName);
    professionCtrl = TextEditingController();
    locationCtrl = TextEditingController();
    contactCtrl = TextEditingController();
    bioCtrl = TextEditingController();
    portfolioCtrl = TextEditingController();
    instagramCtrl = TextEditingController();
    youtubeCtrl = TextEditingController();
  }

  // ---------------------------
  // DISPOSE
  // ---------------------------
  @override
  void dispose() {
    fullNameCtrl.dispose();
    professionCtrl.dispose();
    locationCtrl.dispose();
    contactCtrl.dispose();
    bioCtrl.dispose();
    portfolioCtrl.dispose();
    instagramCtrl.dispose();
    youtubeCtrl.dispose();
    skillCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------
  // VALIDATION
  // --------------------------------------------------------------------
  bool validatePage() {
    if (currentStep == 0) {
      if (fullNameCtrl.text.trim().isEmpty) {
        return coreMessenger("Name is required", messageType: CoreScaffoldMessengerType.error);
      }
      if (professionCtrl.text.trim().isEmpty) {
        return coreMessenger("Profession is required",
            messageType: CoreScaffoldMessengerType.error);
      }
      if (locationCtrl.text.trim().isEmpty) {
        return coreMessenger("Location is required",
            messageType: CoreScaffoldMessengerType.error);
      }
      if (dob.isEmpty) {
        return coreMessenger("Select date of birth",
            messageType: CoreScaffoldMessengerType.error);
      }
      if (contactCtrl.text.trim().length < 10) {
        return coreMessenger("Enter valid phone number",
            messageType: CoreScaffoldMessengerType.error);
      }
      if (bioCtrl.text.trim().isEmpty) {
        return coreMessenger("Bio is required",
            messageType: CoreScaffoldMessengerType.error);
      }
    }

    if (currentStep == 1 && skills.isEmpty) {
      return coreMessenger("Add at least one skill",
          messageType: CoreScaffoldMessengerType.error);
    }

    if (currentStep == 2 && portfolioCtrl.text.trim().isEmpty) {
      return coreMessenger("Portfolio URL is required",
          messageType: CoreScaffoldMessengerType.error);
    }

    return true;
  }

  // --------------------------------------------------------------------
  // NEXT
  // --------------------------------------------------------------------
  void nextPage() {
    if (!validatePage()) return;

    if (currentStep == 2) {
      final body = {
        "name": fullNameCtrl.text.trim(),
        "email": widget.email,
        "password": widget.password,
        "user_type": userType,
        "gender": gender,
        "dob": dob,
        "location": locationCtrl.text.trim(),
        "contact": contactCtrl.text.trim(),
        "bio": bioCtrl.text.trim(),
        "portfolio_url": portfolioCtrl.text.trim(),
        "availability": availability,
        "skills": skills,
        "profession": professionCtrl.text.trim(),
        "instagram": instagramCtrl.text.trim(),
        "youtube": youtubeCtrl.text.trim(),
      };

      logger.f("REGISTER JSON → $body");
      MyNavigator.pushNamed(GoPaths.letsFameHomeScreen);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // --------------------------------------------------------------------
  // UI
  // --------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0A24), Color(0xFF22003D), Color(0xFF0F0A24)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              buildHeader(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => currentStep = i),
                  children: [
                    buildBasicInfoPage(),
                    buildSkillsPage(),
                    buildPortfolioPage(),
                  ],
                ),
              ),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------
  // HEADER
  // --------------------------------------------------------------------
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Setup Your Profile",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 15),
          Row(
            children: List.generate(3, (index) {
              final active = index <= currentStep;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient:
                    active ? const LinearGradient(colors: [Colors.purple, Colors.pink]) : null,
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // FOOTER
  // --------------------------------------------------------------------
  Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: nextPage,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            currentStep == 2 ? "Register User" : "Continue",
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------
  // PAGE 1
  // --------------------------------------------------------------------
  Widget buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          buildInput("Full Name", "Your name", controller: fullNameCtrl),
          buildInput("Profession", "Actor, Director...", controller: professionCtrl),
          buildInput("Location", "City, State", controller: locationCtrl),
          buildGenderSelector(),
          buildDOBPicker(),
          buildInput("Contact Number", "Phone", controller: contactCtrl),
          buildBioInput(),
        ],
      ),
    );
  }

  Widget buildBioInput() {
    return buildMultiline("Bio", "Short introduction", controller: bioCtrl);
  }

  // --------------------------------------------------------------------
  // PAGE 2
  // --------------------------------------------------------------------
  Widget buildSkillsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildInput("Skill", "e.g Acting", controller: skillCtrl),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (skillCtrl.text.trim().isEmpty) return;
                  setState(() {
                    skills.add(skillCtrl.text.trim());
                    skillCtrl.clear();
                  });
                },
                child: const Text("Add"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: skills
                .map(
                  (s) => Chip(
                label: Text(s),
                onDeleted: () => setState(() => skills.remove(s)),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // PAGE 3
  // --------------------------------------------------------------------
  Widget buildPortfolioPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          buildInput("Instagram", "@username", controller: instagramCtrl),
          buildInput("YouTube", "Channel URL", controller: youtubeCtrl),
          buildInput("Portfolio URL", "https://example.com", controller: portfolioCtrl),
          buildAvailabilitySelector(),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // HELPERS
  // --------------------------------------------------------------------
  Widget buildInput(String label, String hint,
      {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMultiline(String label, String hint,
      {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGenderSelector() {
    const genders = ["male", "female", "other"];
    return Row(
      children: genders.map((g) {
        final selected = gender == g;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => gender = g),
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(colors: [Colors.purple, Colors.pink])
                    : null,
                borderRadius: BorderRadius.circular(12),
                border: selected ? null : Border.all(color: Colors.white30),
              ),
              alignment: Alignment.center,
              child: Text(
                g.toUpperCase(),
                style: TextStyle(color: selected ? Colors.white : Colors.grey),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildDOBPicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => dob = DateFormat("yyyy-MM-dd").format(picked));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dob.isEmpty ? "Select Date of Birth" : dob,
                style: const TextStyle(color: Colors.white)),
            const Icon(Icons.calendar_month, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget buildAvailabilitySelector() {
    const options = ["Available", "Busy", "Not Available"];
    return Row(
      children: options.map((o) {
        final selected = availability == o;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => availability = o),
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(colors: [Colors.purple, Colors.pink])
                    : null,
                borderRadius: BorderRadius.circular(12),
                border: selected ? null : Border.all(color: Colors.white30),
              ),
              alignment: Alignment.center,
              child: Text(o,
                  style: TextStyle(color: selected ? Colors.white : Colors.grey)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
