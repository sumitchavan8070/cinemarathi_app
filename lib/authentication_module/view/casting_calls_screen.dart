import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_management/authentication_module/controller/casting_calls_controller.dart';
import 'package:school_management/utils/components/cached_image_network_container.dart';

class CastingCallsScreen extends StatefulWidget {
  final VoidCallback onTap;

  const CastingCallsScreen({super.key, required this.onTap});

  @override
  State<CastingCallsScreen> createState() => _CastingCallsScreenState();
}

class _CastingCallsScreenState extends State<CastingCallsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedGender = 'All';
  final List<String> genderFilters = ['All', 'Male', 'Female', 'Any'];
  late final CastingCallsController _castingController;

  @override
  void initState() {
    super.initState();
    _castingController = Get.put(CastingCallsController());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: widget.onTap,
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
        title: const Text(
          "Casting Calls",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF0D0B1A),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Navigate to create casting call page
              // MyNavigator.pushNamed(GoPaths.createCastingCall);
            },
            tooltip: "Create Casting Call",
          ),
        ],
      ),
      body: Obx(
        () => _castingController.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Search Bar
                    _buildSearchBar(),

                    const SizedBox(height: 20),

                    // Gender Filter
                    _buildGenderFilter(),

                    const SizedBox(height: 20),

                    // Casting Calls List
                    if (_castingController.castingCalls.isEmpty)
                      _buildEmptyState()
                    else
                      ..._castingController.castingCalls
                          .map((call) => _castingCallCard(call))
                          .toList(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                fillColor: Colors.transparent,

                hintText: "Search casting calls...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: (value) {
                _performSearch();
              },
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
    );
  }

  Widget _buildGenderFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: genderFilters.map((gender) {
          bool selected = gender == selectedGender;
          return GestureDetector(
            onTap: () {
              setState(() => selectedGender = gender);
              _performSearch();
            },
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
                gender,
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
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.cast, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("No Casting Calls Found", style: TextStyle(color: Colors.grey[400], fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            "Check back later for new opportunities",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _castingCallCard(Map<String, dynamic> call) {
    final projectTitle = call["project_title"] ?? "Untitled Project";
    final role = call["role"] ?? "Role not specified";
    final productionHouse = call["production_house_name"] ?? "Production House";
    final profilePic = call["production_house_profile_picture"] ?? "";
    final location = call["location"] ?? "Location not specified";
    final budgetValue = call["budget_per_day"];
    final budget = _parseBudget(budgetValue);
    final gender = call["gender"] ?? "any";
    final minAge = call["min_age"] ?? 0;
    final maxAge = call["max_age"] ?? 100;
    final auditionDate = call["audition_date"];
    final description = call["description"] ?? "";
    final totalApplications = call["total_applications"] ?? 0;
    final castingCallId = call["id"] ?? 0;

    final hasApplied = _castingController.hasApplied(castingCallId);
    final applicationStatus = _castingController.getApplicationStatus(castingCallId);
    final isActive = _castingController.isCastingCallActive(call);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? Colors.white24 : Colors.grey.withOpacity(0.3),
          width: isActive ? 1 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Production House + Title
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white12,
                child: profilePic.toString().isNotEmpty
                    ? ClipOval(
                        child: CachedImageNetworkContainer(
                          url: profilePic.toString(),
                          placeHolder: buildPlaceholder(name: "PH", context: context),
                        ),
                      )
                    : const Icon(Icons.business, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(productionHouse, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              // Status badges
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Active/Inactive status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isActive ? "Active" : "Closed",
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasApplied) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(applicationStatus).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusText(applicationStatus),
                        style: TextStyle(
                          color: _getStatusColor(applicationStatus),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Role + Gender + Age
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(role, Colors.purpleAccent),
              _infoChip(gender.toString().toUpperCase(), Colors.pinkAccent),
              _infoChip("Age: $minAge-$maxAge", Colors.blueAccent),
            ],
          ),

          const SizedBox(height: 12),

          // Description
          if (description.isNotEmpty)
            Text(
              description.length > 150 ? "${description.substring(0, 150)}..." : description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              maxLines: 3,
            ),

          const SizedBox(height: 16),

          // Details Row
          _detailRow(Icons.location_on, location),
          const SizedBox(height: 8),
          _detailRow(Icons.currency_rupee, "₹$budget/day"),
          const SizedBox(height: 8),
          if (auditionDate != null)
            _detailRow(Icons.calendar_today, "Audition: ${_formatDate(auditionDate)}"),
          const SizedBox(height: 8),
          _detailRow(Icons.people, "$totalApplications applications"),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              // Expanded(
              //   child: GestureDetector(
              //     onTap: () => _showCastingCallDetails(call),
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //       decoration: BoxDecoration(
              //         color: Colors.white.withOpacity(0.08),
              //         borderRadius: BorderRadius.circular(14),
              //       ),
              //       alignment: Alignment.center,
              //       child: const Text("View Details", style: TextStyle(color: Colors.white)),
              //     ),
              //   ),
              // ),
              const SizedBox(width: 12),
              if (!hasApplied && isActive)
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showApplyDialog(castingCallId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.pink, Colors.purple]),
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Apply Now", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              if (!hasApplied && !isActive)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Text("Closed", style: TextStyle(color: Colors.grey)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      ],
    );
  }

  String _formatDate(dynamic date) {
    try {
      if (date is String) {
        final parsed = DateTime.parse(date);
        return DateFormat('MMM dd, yyyy').format(parsed);
      }
      return date.toString();
    } catch (e) {
      return date.toString();
    }
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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'applied':
        return Colors.blue;
      case 'shortlisted':
        return Colors.orange;
      case 'selected':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'applied':
        return 'Applied';
      case 'shortlisted':
        return 'Shortlisted';
      case 'selected':
        return 'Selected';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Applied';
    }
  }

  void _performSearch() {
    final keyword = _searchController.text.trim();
    // Map UI gender filter to API format: "All" -> null, "Male" -> "male", "Female" -> "female", "Any" -> "any"
    String? gender;
    if (selectedGender == 'All') {
      gender = null;
    } else if (selectedGender == 'Male') {
      gender = 'male';
    } else if (selectedGender == 'Female') {
      gender = 'female';
    } else if (selectedGender == 'Any') {
      gender = 'any';
    }

    if (keyword.isEmpty && gender == null) {
      _castingController.fetchCastingCalls();
    } else {
      _castingController.searchCastingCalls(
        keyword: keyword.isEmpty ? null : keyword,
        gender: gender,
      );
    }
  }

  void _showCastingCallDetails(Map<String, dynamic> call) {
    // Navigate to details page or show bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildDetailsSheet(call),
    );
  }

  Widget _buildDetailsSheet(Map<String, dynamic> call) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            call["project_title"] ?? "Casting Call Details",
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Add more details here
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showApplyDialog(int castingCallId) {
    final auditionLinkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text("Apply to Casting Call", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: auditionLinkController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                fillColor: Colors.transparent,
                labelText: "Audition Link (Optional)",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: "https://youtube.com/watch?v=...",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _castingController.applyToCastingCall(
                castingCallId,
                auditionLink: auditionLinkController.text.trim().isEmpty
                    ? null
                    : auditionLinkController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }
}
