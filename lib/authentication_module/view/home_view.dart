import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/controller/client_dashboard_controller.dart';
import 'package:school_management/authentication_module/model/client_dashboard_details_model.dart';
import 'package:school_management/utils/components/cached_image_network_container.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/asset_paths.dart';

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

                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Colors.pink, Colors.purple]),
                  ),
                  child: const ClipOval(
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage("https://avatars.githubusercontent.com/u/111274627?v=4"),
                    ),
                  ),
                ),
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
