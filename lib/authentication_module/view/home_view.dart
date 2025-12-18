import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/controller/cine_profile_controller.dart';
import 'package:school_management/authentication_module/controller/client_dashboard_controller.dart';
import 'package:school_management/authentication_module/controller/casting_calls_controller.dart';
import 'package:school_management/authentication_module/model/client_dashboard_details_model.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/components/cached_image_network_container.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/asset_paths.dart';
import 'package:school_management/utils/constants/core_prep_paths.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';
import 'package:get/get.dart';

final ProfileController _profileController = Get.put(ProfileController());

class HomeView extends StatelessWidget {
  final VoidCallback onTap;

  HomeView({super.key, required this.onTap});

  final ClientDashboardController controller = Get.find<ClientDashboardController>();

  @override
  Widget build(BuildContext context) {

    return controller.obx(
      (state) => _buildBody(context, state),
      onLoading: const Scaffold(
        backgroundColor: Color(0xFF0D0B1A),
        body: Center(child: CircularProgressIndicator()),
      ),
      onError: (e) => Scaffold(
        backgroundColor: const Color(0xFF0D0B1A),
        body: Center(
          child: Text(e ?? "Something went wrong", style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ClientDashboardDetailsModel? state) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // --------------------------------------------------
          // HEADER
          // --------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: SvgPicture.asset(AssetPaths.menuSVG),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CineMarathi",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(height: 4),
                        Text(
                          "Where Talent Meets Opportunity",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                Obx(() {
                  if (_profileController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
                  }

                  final p = _profileController.profile;
                  return Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Colors.pink, Colors.purple]),
                    ),
                    child: CachedImageNetworkContainer(
                      fit: BoxFit.cover,
                      url: (p["avatar"] ?? "").toString().replaceAll(" ", ""),

                      placeHolder: buildPlaceholder(name: "User", context: context),
                    ),
                    // child: ,
                  );
                }),
              ],
            ),
          ),

          // --------------------------------------------------
          // CONTENT
          // --------------------------------------------------
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PlanCarousel(bannerList: state?.bannerList),

                  const SizedBox(height: 25),

                  _sectionTitle("Featured Talents"),
                  const SizedBox(height: 15),

                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: state?.featuredTalents?.length ?? 0,
                      itemBuilder: (_, index) {
                        final item = state!.featuredTalents![index];
                        return _talentCard(
                          context,
                          item.name ?? "-",
                          item.profession ?? "-",
                          item.avatar ?? "https://api.dicebear.com/7.x/adventurer/svg",
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  _sectionTitle("Trending Today"),
                  const SizedBox(height: 15),

                  ...List.generate(state?.trendingJobs?.length ?? 0, (index) {
                    final job = state!.trendingJobs![index];
                    return _jobCard(
                      context,
                      title: job.title ?? "-",
                      company: job.company ?? "-",
                      tag: job.tag ?? "-",
                      location: job.location ?? "-",
                    );
                  }),

                  const SizedBox(height: 30),

                  _buildCastingCallsSection(context),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const Text("See All >", style: TextStyle(color: Colors.purpleAccent)),
        ],
      ),
    );
  }

  Widget _talentCard(BuildContext context, String name, String role, String imgUrl) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: SvgPicture.network(imgUrl),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          Text(
            role,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _jobCard(
    BuildContext context, {
    required String title,
    required String company,
    required String tag,
    required String location,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(company, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.purpleAccent),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              Text(
                location,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCastingCallsSection(BuildContext context) {
    final castingController = Get.put(CastingCallsController());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Casting Calls",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  MyNavigator.pushNamed(GoPaths.castingCalls);
                },
                child: const Text("See All >", style: TextStyle(color: Colors.purpleAccent)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Obx(() {
          if (castingController.isLoading.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Colors.pinkAccent),
              ),
            );
          }
          
          // Show only active casting calls, limit to 3
          final activeCalls = castingController.getActiveCastingCalls().take(3).toList();
          final calls = activeCalls;
          
          if (calls.isEmpty) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Text(
                  "No casting calls available",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }
          
          return SizedBox(
            height: 220,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: calls.length,
              itemBuilder: (context, index) {
                final call = calls[index];
                return _castingCallCard(context, call);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _castingCallCard(BuildContext context, Map<String, dynamic> call) {
    final projectTitle = call["project_title"] ?? "Casting Call";
    final role = call["role"] ?? "Role";
    final productionHouse = call["production_house_name"] ?? "Production";
    final location = call["location"] ?? "Location";
    final budgetValue = call["budget_per_day"];
    final budget = _parseBudget(budgetValue);
    final castingCallId = call["id"] ?? 0;
    final castingController = Get.find<CastingCallsController>();
    final isActive = castingController.isCastingCallActive(call);
    
    return GestureDetector(
      onTap: () {
        MyNavigator.pushNamed(GoPaths.castingCalls);
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purple]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.cast, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                projectTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: isActive 
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isActive ? Colors.green : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isActive ? "Active" : "Closed",
                                    style: TextStyle(
                                      color: isActive ? Colors.green : Colors.grey,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          productionHouse,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role,
                style: const TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.currency_rupee, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "₹$budget/day",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purple]),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                "View Details",
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _parseBudget(dynamic budget) {
    try {
      if (budget == null) return "0";
      if (budget is num) {
        return budget.toStringAsFixed(0);
      }
      if (budget is String) {
        final parsed = double.tryParse(budget);
        if (parsed != null) {
          return parsed.toStringAsFixed(0);
        }
        return budget;
      }
      return budget.toString();
    } catch (e) {
      return "0";
    }
  }
}

class PlanCarousel extends StatefulWidget {
  final List<BannerList>? bannerList;

  const PlanCarousel({super.key, required this.bannerList});

  @override
  State<PlanCarousel> createState() => _PlanCarouselState();
}

class _PlanCarouselState extends State<PlanCarousel> with AutomaticKeepAliveClientMixin {
  late final PageController _controller;

  int currentIndex = 0;
  Timer? _autoScrollTimer;

  static const int _fakeItemCount = 100000; // big number
  late final int _initialPage;

  @override
  void initState() {
    super.initState();

    final length = widget.bannerList?.length ?? 0;
    _initialPage = length == 0 ? 0 : _fakeItemCount ~/ 2;

    _controller = PageController(viewportFraction: 0.88, initialPage: _initialPage);

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_controller.hasClients) return;

      _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final banners = widget.bannerList;
    if (banners == null || banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: _fakeItemCount,
            onPageChanged: (pageIndex) {
              setState(() {
                currentIndex = pageIndex % banners.length;
              });
            },
            itemBuilder: (context, index) {
              final realIndex = index % banners.length;
              final p = banners[realIndex];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                clipBehavior: Clip.hardEdge,
                decoration: AppBoxDecoration.getBoxDecoration(showShadow: true, borderRadius: 20),
                child: CachedImageNetworkContainer(
                  url: p.image ?? "",
                  placeHolder: buildPlaceholder(name: "Sumit", context: context),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            final active = index == currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: active ? 22 : 8,
              decoration: BoxDecoration(
                color: active ? Colors.pinkAccent : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }
}
