import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/controller/cine_profile_controller.dart';
import 'package:school_management/utils/navigation/navigator.dart';

final ProfileController controller = Get.put(ProfileController());

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  // final controller = Get.find<ClientDashboardController>();

  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController locationController;
  late TextEditingController professionController;
  late TextEditingController contactController;
  late TextEditingController instagramController;
  late TextEditingController youtubeController;
  late TextEditingController skillsController;

  @override
  void initState() {
    super.initState();

    final p = controller.profile;

    nameController = TextEditingController(text: p["name"] ?? "");
    bioController = TextEditingController(text: p["bio"] ?? p["about"] ?? "");
    locationController = TextEditingController(text: p["location"] ?? p["address"] ?? "");
    professionController = TextEditingController(text: p["profession"] ?? "");
    contactController = TextEditingController(text: p["contact"] ?? p["phone"] ?? "");
    instagramController = TextEditingController(text: p["social"]?["instagram"] ?? "");
    youtubeController = TextEditingController(text: p["social"]?["youtube"] ?? "");
    skillsController = TextEditingController(text: (p["skills"] as List?)?.join(", ") ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    locationController.dispose();
    professionController.dispose();
    contactController.dispose();
    instagramController.dispose();
    youtubeController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            MyNavigator.pop();
          },
          child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
        title: Text(
          "Edit Profile",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF0D0B1A),
      ),
      body: Column(
        children: [
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              // controller: scrollController,
              child: Column(
                children: [
                  _buildTextField("Name", nameController),
                  const SizedBox(height: 16),
                  _buildTextField("Bio", bioController, maxLines: 3),
                  const SizedBox(height: 16),
                  _buildTextField("Location", locationController),
                  const SizedBox(height: 16),
                  _buildTextField("Profession", professionController),
                  const SizedBox(height: 16),
                  _buildTextField(
                    "Contact",
                    contactController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    "Skills (comma separated)",
                    skillsController,
                    hint: "Acting, Dancing, Singing",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField("Instagram", instagramController, hint: "@username or URL"),
                  const SizedBox(height: 16),
                  _buildTextField("YouTube", youtubeController, hint: "Channel URL"),
                  const SizedBox(height: 30),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isUploading.value ? null : _onSavePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: controller.isUploading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Save Changes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSavePressed() async {
    List<String>? skills;
    if (skillsController.text.isNotEmpty) {
      skills = skillsController.text
          .split(",")
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    await controller.updateProfile(
      name: nameController.text.trim().isEmpty ? null : nameController.text.trim(),
      bio: bioController.text.trim().isEmpty ? null : bioController.text.trim(),
      location: locationController.text.trim().isEmpty ? null : locationController.text.trim(),
      profession: professionController.text.trim().isEmpty
          ? null
          : professionController.text.trim(),
      contact: contactController.text.trim().isEmpty ? null : contactController.text.trim(),
      skills: skills?.isEmpty ?? true ? null : skills,
      instagram: instagramController.text.trim().isEmpty ? null : instagramController.text.trim(),
      youtube: youtubeController.text.trim().isEmpty ? null : youtubeController.text.trim(),
    );

    if (!controller.isUploading.value && mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
