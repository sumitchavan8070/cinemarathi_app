import 'dart:async';
import 'package:get/get.dart';
import 'package:school_management/utils/dio/api_request.dart';
import 'package:school_management/utils/dio/api_end_points.dart';

import '../../constants.dart';

// class TalentsController extends GetxController {
//   // Talents list
//   RxList talents = [].obs;
//
//   // Categories list
//   RxList categories = [].obs;
//
//   // Selected filter
//   RxString selectedCategory = "All".obs;
//
//   // Search text
//   RxString searchQuery = "".obs;
//
//   // Loading state
//   RxBool isLoading = false.obs;
//
//   Timer? _debounce;
//
//   @override
//   void onInit() {
//     fetchCategories();
//     fetchTalents();
//     super.onInit();
//   }
//
//   // -------------------------------------------------------------------
//   // FETCH CATEGORIES
//   // -------------------------------------------------------------------
//   Future<void> fetchCategories() async {
//     try {
//       final res = await getRequest(apiEndPoint: "users/talent/categories");
//
//       logger.e("categories ${res.data}");
//
//       if (res.statusCode == 200) {
//         List items = res.data["categories"];
//         categories.assignAll([ ...items]);
//       }
//     } catch (e) {
//       print("Error loading categories: $e");
//     }
//   }
//
//   // -------------------------------------------------------------------
//   // FETCH TALENTS
//   // -------------------------------------------------------------------
//   Future<void> fetchTalents() async {
//     isLoading.value = true;
//
//     try {
//       String cat = selectedCategory.value == "All" ? "" : selectedCategory.value;
//
//       final url =
//           "/users/talents?search=${searchQuery.value}&category=$cat&page=1";
//
//       final res = await getRequest(apiEndPoint: url);
//
//       if (res.statusCode == 200) {
//         talents.assignAll(res.data["talents"]);
//       }
//     } catch (e) {
//       print("Error fetching talents: $e");
//     }
//
//     isLoading.value = false;
//   }
//
//   // -------------------------------------------------------------------
//   // SEARCH DEBOUNCE
//   // -------------------------------------------------------------------
//   void search(String value) {
//     searchQuery.value = value;
//
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       fetchTalents();
//     });
//   }
//
//   // -------------------------------------------------------------------
//   // CATEGORY SELECTOR
//   // -------------------------------------------------------------------
//   void updateCategory(String cat) {
//     selectedCategory.value = cat;
//     fetchTalents();
//   }
// }

class TalentsController extends GetxController {
  // --------------------------
  // OBSERVABLES
  // --------------------------
  RxList talents = [].obs;
  RxList categories = [].obs;

  RxString selectedCategory = "All".obs;
  RxString searchQuery = "".obs;

  RxBool isLoading = false.obs; // First API load
  RxBool isPaginating = false.obs; // Pagination loading
  RxBool showBottomLoader = false.obs; // 2-second artificial loader

  int page = 1;
  final int limit = 20;

  Timer? _debounce;

  // --------------------------
  // INIT
  // --------------------------
  @override
  void onInit() {
    fetchCategories();
    fetchTalents(reset: true);
    super.onInit();
  }

  // ---------------------------------------------------------
  // FETCH CATEGORIES
  // ---------------------------------------------------------
  Future<void> fetchCategories() async {
    try {
      final res = await getRequest(
        apiEndPoint: APIEndPoints.talentCategories, // "/users/talent/categories"
      );

      if (res.statusCode == 200) {
        List raw = res.data["categories"] ?? [];

        // Convert to List<String>
        List<String> cats = raw.map((e) => e.toString()).toList();

        // Remove backend "All" to avoid duplicates
        cats.removeWhere((e) => e.trim().toLowerCase() == "all");

        categories.assignAll(["All", ...cats]);
      }
    } catch (e) {
      print("CATEGORY ERROR: $e");
    }
  }

  // ---------------------------------------------------------
  // FETCH TALENTS (MAIN + PAGINATION)
  // ---------------------------------------------------------
  Future<void> fetchTalents({bool reset = false}) async {
    try {
      if (reset) {
        page = 1;
        talents.clear();
        isLoading.value = true;
      } else {
        if (isPaginating.value) return;
        isPaginating.value = true;
      }

      final String cat = selectedCategory.value == "All" ? "" : selectedCategory.value;

      final String url =
          "/users/talents?search=${searchQuery.value}&category=$cat&page=$page&limit=$limit";

      final res = await getRequest(apiEndPoint: url);

      if (res.statusCode == 200) {
        List newTalents = res.data["talents"] ?? [];

        if (reset) {
          talents.assignAll(newTalents);
        } else {
          talents.addAll(newTalents);
        }

        // Increase page number for next load
        if (newTalents.isNotEmpty) {
          page++;
        }
      }
    } catch (e) {
      print("TALENTS FETCH ERROR: $e");
    }

    // Reset loaders
    isLoading.value = false;
    isPaginating.value = false;
  }

  // ---------------------------------------------------------
  // DEBOUNCED SEARCH
  // ---------------------------------------------------------
  void search(String value) {
    searchQuery.value = value;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchTalents(reset: true); // reset list for new search
    });
  }

  // ---------------------------------------------------------
  // UPDATE CATEGORY
  // ---------------------------------------------------------
  void updateCategory(String cat) {
    selectedCategory.value = cat;
    fetchTalents(reset: true); // reset for new category
  }
}
