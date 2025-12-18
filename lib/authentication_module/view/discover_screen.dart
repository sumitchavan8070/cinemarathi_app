import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/controller/talents_controller.dart';
import 'package:school_management/utils/components/cached_image_network_container.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';

class DiscoverTalentsScreen extends StatelessWidget {
  DiscoverTalentsScreen({super.key});

  final TalentsController controller = Get.put(TalentsController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // LISTENER FOR PAGINATION
    scrollController.addListener(() async {
      if (!controller.isPaginating.value &&
          scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        controller.showBottomLoader.value = true;

        // WAIT 2 SECONDS BEFORE API CALL
        await Future.delayed(const Duration(seconds: 2));

        controller.showBottomLoader.value = false;

        controller.fetchTalents(); // CALL PAGINATION API
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Explore Auditions",
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
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
                          onChanged: controller.search,
                          decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            hintText: "Search talents...",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _filterIcon(),
                  ],
                ),

                const SizedBox(height: 20),
                SizedBox(
                  height: 45,
                  child: Obx(() {
                    if (controller.categories.isEmpty) {
                      return const Center(
                        child: Text("Loading categories...", style: TextStyle(color: Colors.grey)),
                      );
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.categories.map((cat) {
                          bool selected = controller.selectedCategory.value == cat;

                          return GestureDetector(
                            onTap: () => controller.updateCategory(cat),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: selected
                                    ? const LinearGradient(colors: [Colors.pink, Colors.purple])
                                    : null,
                                color: selected ? null : Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selected ? Colors.transparent : Colors.white24,
                                ),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 25),

                if (controller.isLoading.value)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                if (!controller.isLoading.value)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.talents.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 260,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      final t = controller.talents[index];

                      return _talentCard(
                        name: t["name"] ?? "",
                        role: t["profession"] ?? t["role"] ?? "",
                        location: t["location"] ?? "",
                        imageUrl:
                            t["image"].toString().replaceAll(" ", "") ??
                            "https://avatars.githubusercontent.com/u/111274627?v=4",
                        context: context,
                      );
                    },
                  ),
                Obx(() {
                  return controller.showBottomLoader.value
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
                        )
                      : const SizedBox();
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  // FILTER ICON
  Widget _filterIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.filter_alt_outlined, color: Colors.white),
    );
  }

  // TALENT CARD UI
  Widget _talentCard({
    required String name,
    required String role,
    required String location,
    required String imageUrl,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Center(
            child: CachedImageNetworkContainer(
              height: 80,
              width: 80,
              decoration: AppBoxDecoration.getBoxDecoration(borderRadius: 100),
              fit: BoxFit.cover,
              url: imageUrl,
              placeHolder: buildPlaceholder(name: name, context: context),
            ),
          ),
          const SizedBox(height: 10),

          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),

          Text(role, style: const TextStyle(color: Colors.grey, fontSize: 13)),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 16),
              const SizedBox(width: 3),
              Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.pink, Colors.purple]),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            alignment: Alignment.center,
            child: const Text("View Profile", style: TextStyle(color: Colors.white)),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
