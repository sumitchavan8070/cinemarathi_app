import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_management/authentication_module/controller/cine_profile_controller.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/components/cached_image_network_container.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onTap;

  ProfileScreen({super.key, required this.onTap});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: onTap,

          child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
        title: Text(
          "Profile",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF0D0B1A),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
        }

        final p = controller.profile;
        final stats = controller.stats;

        logger.e(controller.portfolio);

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  _buildHeaderSection(
                    context: context,
                    name: p["name"] ?? "Unknown",
                    profession: p["profession"] ?? "No profession",
                    location: p["location"] ?? p["address"] ?? "Location not added",
                    avatar: (p["avatar"] ?? "").toString().replaceAll(" ", ""),
                    isVerified: p["is_verified"] ?? false,
                  ),

                  const SizedBox(height: 16),
                  const SizedBox(height: 16),

                  // Edit Profile Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        MyNavigator.pushNamed(GoPaths.editProfile);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.pinkAccent, Colors.purple],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats: Followers / Following / Projects
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _statBox(
                          stats["followers"]?.toString() ??
                              stats["profile_views"]?.toString() ??
                              "0",
                          "Followers",
                        ),
                        const SizedBox(width: 10),
                        _statBox(
                          stats["following"]?.toString() ?? stats["connections"]?.toString() ?? "0",
                          "Following",
                        ),
                        const SizedBox(width: 10),
                        _statBox(stats["projects"]?.toString() ?? "0", "Projects"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ABOUT
                  _sectionTitle("About"),
                  _sectionText((p["bio"] ?? p["about"] ?? "No bio added yet.") as String),

                  const SizedBox(height: 20),

                  // SKILLS
                  _sectionTitle("Skills"),
                  _buildSkills(p["skills"] ?? []),

                  const SizedBox(height: 30),

                  // SOCIAL
                  if ((p["social"] ?? {}).isNotEmpty) ...[
                    _sectionTitle("Social"),
                    const SizedBox(height: 10),

                    _buildSocial(p["social"] ?? {}),
                    const SizedBox(height: 30),
                  ],

                  // PORTFOLIO
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Portfolio",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (controller.portfolio.length >= 6)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.withOpacity(0.5)),
                            ),
                            child: Text(
                              "6/6 Images",
                              style: TextStyle(
                                color: Colors.orange[300],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Center(child: _buildPortfolioGrid(controller.portfolio, context)),

                  const SizedBox(height: 30),

                  // REVIEWS (placeholder)
                  _sectionTitle("Reviews"),
                  _buildReviewsSection(p["reviews"]),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Upload loading overlay
            if (controller.isUploading.value)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.pinkAccent),
                      SizedBox(height: 16),
                      Text(
                        "Uploading image...",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // ================= HEADER SECTION =================
  Widget _buildHeaderSection({
    required BuildContext context,
    required String name,
    required String profession,
    required String location,
    required String avatar,
    required bool isVerified,
  }) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _showImageSourceDialog(context),
              child: Stack(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFD9AF),
                    ),
                    child: CachedImageNetworkContainer(
                      fit: BoxFit.cover,
                      url: avatar,

                      placeHolder: buildPlaceholder(name: "User", context: context),
                    ),
                    // child: ,
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // Name, profession, location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isVerified)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.verified, color: Colors.blueAccent, size: 20),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profession,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STATS BOX =================
  Widget _statBox(String value, String label) => Expanded(
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
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    ),
  );

  // ================= SECTION HELPERS =================
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(text, style: const TextStyle(color: Colors.grey, height: 1.4)),
    );
  }

  // ================= SKILLS =================
  Widget _buildSkills(List skills) {
    if (skills.isEmpty || skills == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(Icons.workspace_premium, color: Colors.grey[400], size: 48),
              const SizedBox(height: 12),
              Text(
                "No Skills",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Add your skills to showcase your talents",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: skills.map<Widget>((s) => _skillChip(s.toString())).toList(),
      ),
    );
  }

  Widget _skillChip(String txt) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white24),
    ),
    child: Text(txt, style: const TextStyle(color: Colors.white)),
  );

  // ================= SOCIAL LINKS =================
  Widget _buildSocial(Map social) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        children: [
          if (social["instagram"] != null)
            _socialChip(Icons.camera_alt, social["instagram"].toString()),
          if (social["youtube"] != null)
            _socialChip(Icons.video_collection, social["youtube"].toString()),
          if (social["imdb"] != null) _socialChip(Icons.movie, "IMDb"),
        ],
      ),
    );
  }

  Widget _socialChip(IconData icon, String txt) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.purpleAccent),
        const SizedBox(width: 6),
        Text(txt, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );

  // ================= PORTFOLIO GRID =================
  Widget _buildPortfolioGrid(List items, BuildContext context) {
    final int currentCount = items.length;
    final bool canAddMore = currentCount < 6;

    if (items.isEmpty) {
      return GestureDetector(
        onTap: canAddMore ? () => _showSinglePortfolioImageSourceDialog(context) : null,
        child: Container(
          height: 200,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.pinkAccent.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_photo_alternate, color: Colors.pinkAccent, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                "Add Portfolio Images",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                "Tap to upload up to 6 images",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    // Show grid with add button only if less than 6 images (strict check)
    // canAddMore is already declared above

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: canAddMore ? items.length + 1 : items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          // Show add button as last item ONLY if can add more (less than 6 images)
          if (canAddMore && index == items.length) {
            return GestureDetector(
              onTap: () => _showSinglePortfolioImageSourceDialog(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.pinkAccent.withOpacity(0.3), width: 2),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.pinkAccent, size: 32),
                    SizedBox(height: 8),
                    Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // If at 6 images, don't show add button (this should never execute due to itemCount check, but added for safety)
          if (!canAddMore && index >= items.length) {
            return const SizedBox.shrink();
          }

          final item = items[index];
          final url = item["url"]?.toString() ?? item["imageUrl"]?.toString() ?? "";
          return GestureDetector(
            onTap: () => _showPortfolioImageOptionsDialog(context, index + 1, url),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedImageNetworkContainer(
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.14,
                    width: MediaQuery.of(context).size.height * 0.12,
                    url: url,

                    placeHolder: buildPlaceholder(name: "User", context: context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= REVIEWS SECTION =================
  Widget _buildReviewsSection(dynamic reviewsData) {
    if (reviewsData == null || (reviewsData is List && reviewsData.isEmpty)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(Icons.rate_review, color: Colors.grey[400], size: 48),
              const SizedBox(height: 12),
              Text(
                "No Reviews",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Reviews will appear here once you receive feedback",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // If reviews is a list, display them
    if (reviewsData is List) {
      return Column(
        children: reviewsData.map<Widget>((review) {
          return _reviewCard(
            name: review["name"] ?? review["reviewer_name"] ?? "Anonymous",
            review: review["review"] ?? review["comment"] ?? review["text"] ?? "",
          );
        }).toList(),
      );
    }

    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text("No reviews yet.", style: TextStyle(color: Colors.grey)),
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

  // ================= AVATAR IMAGE BUILDER =================
  Widget _buildAvatarImage(String avatarUrl) {
    // Handle empty or null URL
    if (avatarUrl.isEmpty || avatarUrl.trim().isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.person, size: 40, color: Colors.grey),
      );
    }

    // Check if URL is SVG or regular image
    if (avatarUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        avatarUrl,
        fit: BoxFit.cover,
        placeholderBuilder: (context) =>
            const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
      );
    } else {
      return Image.network(
        avatarUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.person, size: 40, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
        },
      );
    }
  }

  // ================= IMAGE SOURCE DIALOG =================
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Select Image Source",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Options
                _buildImageSourceOption(
                  context,
                  icon: Icons.photo_library,
                  title: "Choose from Gallery",
                  subtitle: "Select an image from your gallery",
                  onTap: () {
                    Navigator.pop(context);
                    controller.uploadProfileImage(source: ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 12),
                _buildImageSourceOption(
                  context,
                  icon: Icons.camera_alt,
                  title: "Take a Photo",
                  subtitle: "Capture a new photo with camera",
                  onTap: () {
                    Navigator.pop(context);
                    controller.uploadProfileImage(source: ImageSource.camera);
                  },
                ),
                const SizedBox(height: 20),
                // Cancel button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[700]!),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= IMAGE SOURCE OPTION WIDGET =================
  Widget _buildImageSourceOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.pinkAccent, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SINGLE PORTFOLIO IMAGE SOURCE DIALOG =================
  void _showSinglePortfolioImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Add Portfolio Image",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Options
              _buildImageSourceOption(
                context,
                icon: Icons.photo_library,
                title: "Choose from Gallery",
                subtitle: "Select an image from your gallery",
                onTap: () {
                  Navigator.pop(context);
                  controller.uploadSinglePortfolioImage(source: ImageSource.gallery);
                },
              ),
              const SizedBox(height: 12),
              _buildImageSourceOption(
                context,
                icon: Icons.camera_alt,
                title: "Take a Photo",
                subtitle: "Capture a new photo with camera",
                onTap: () {
                  Navigator.pop(context);
                  controller.uploadSinglePortfolioImage(source: ImageSource.camera);
                },
              ),
              const SizedBox(height: 20),
              // Cancel button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[700]!),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= MULTIPLE PORTFOLIO IMAGE SOURCE DIALOG =================
  void _showPortfolioImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Add Portfolio Images", style: Theme.of(context).textTheme.bodyLarge),
                ),
                // Options
                _buildImageSourceOption(
                  context,
                  icon: Icons.photo_library,
                  title: "Choose from Gallery",
                  subtitle: "Select images from your gallery",
                  onTap: () {
                    Navigator.pop(context);
                    controller.uploadPortfolioImages(source: ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 12),
                _buildImageSourceOption(
                  context,
                  icon: Icons.camera_alt,
                  title: "Take Photos",
                  subtitle: "Capture new photos with camera",
                  onTap: () {
                    Navigator.pop(context);
                    controller.uploadPortfolioImages(source: ImageSource.camera);
                  },
                ),
                const SizedBox(height: 20),
                // Cancel button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[700]!),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= PORTFOLIO IMAGE OPTIONS DIALOG =================
  void _showPortfolioImageOptionsDialog(BuildContext context, int index, String imageUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Portfolio Image Options",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // View Image option
                _buildImageSourceOption(
                  context,
                  icon: Icons.visibility,
                  title: "View Image",
                  subtitle: "View image in full screen",
                  onTap: () {
                    Navigator.pop(context);
                    _showFullScreenImage(context, imageUrl, index);
                  },
                ),
                const SizedBox(height: 12),
                // Replace with Gallery
                _buildImageSourceOption(
                  context,
                  icon: Icons.photo_library,
                  title: "Replace from Gallery",
                  subtitle: "Select an image from your gallery",
                  onTap: () {
                    Navigator.pop(context);
                    controller.uploadSinglePortfolioImage(
                      source: ImageSource.gallery,
                      index: index,
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Replace with Camera
                _buildImageSourceOption(
                  context,
                  icon: Icons.camera_alt,
                  title: "Replace with Camera",
                  subtitle: "Take a new photo",
                  onTap: () {
                    Navigator.pop(context);
                    controller.uploadSinglePortfolioImage(source: ImageSource.camera, index: index);
                  },
                ),
                const SizedBox(height: 12),
                // Delete option
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmationDialog(context, index);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 24),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delete Image",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Remove this image from portfolio",
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Cancel button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[700]!),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= FULL SCREEN IMAGE VIEWER =================
  void _showFullScreenImage(BuildContext context, String imageUrl, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Full screen image
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedImageNetworkContainer(
                    fit: BoxFit.contain,
                    url: imageUrl,
                    placeHolder: buildPlaceholder(name: "Image", context: context),
                  ),
                ),
              ),
              // Close button (top right)
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),
              // Remove Image button (bottom center)
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Remove Image button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context); // Close full screen
                            _showDeleteConfirmationDialog(context, index);
                          },
                          icon: const Icon(Icons.delete_outline, size: 20),
                          label: const Text("Remove Image"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Replace Image button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context); // Close full screen
                            _showReplaceImageOptions(context, index);
                          },
                          icon: const Icon(Icons.swap_horiz, size: 20),
                          label: const Text("Replace"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= REPLACE IMAGE OPTIONS =================
  void _showReplaceImageOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Replace Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildImageSourceOption(
                  context,
                  icon: Icons.photo_library,
                  title: "Choose from Gallery",
                  subtitle: "Select an image from your gallery",
                  onTap: () {
                    Navigator.pop(context);
                    controller.uploadSinglePortfolioImage(
                      source: ImageSource.gallery,
                      index: index,
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildImageSourceOption(
                  context,
                  icon: Icons.camera_alt,
                  title: "Take a Photo",
                  subtitle: "Capture a new photo with camera",
                  onTap: () {
                    Navigator.pop(context);
                    controller.uploadSinglePortfolioImage(source: ImageSource.camera, index: index);
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[700]!),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= DELETE CONFIRMATION DIALOG =================
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Delete Image",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to remove this image from your portfolio?",
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                controller.deletePortfolioImage(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
