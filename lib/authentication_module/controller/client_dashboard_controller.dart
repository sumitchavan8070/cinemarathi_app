import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/model/client_dashboard_details_model.dart';
import 'package:school_management/authentication_module/model/client_profile_model.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class ClientDashboardController extends GetxController
    with StateMixin<ClientDashboardDetailsModel> {

  bool _loaded = false; // 🔥 prevents multiple API calls

  @override
  void onInit() {
    super.onInit();
    getClientDashboardDetails();
  }

  Future<void> getClientDashboardDetails() async {
    if (_loaded) {
      debugPrint("Dashboard already loaded — skipping API call");
      return;
    }

    _loaded = true;

    const apiEndPoint = APIEndPoints.getDashboard;
    debugPrint("---------- $apiEndPoint START ----------");

    try {
      change(null, status: RxStatus.loading());

      final response = await getRequest(apiEndPoint: apiEndPoint);

      debugPrint(
        "ClientDashboardController => Success ${response.data}",
      );

      final model = ClientDashboardDetailsModel.fromJson(response.data);
      change(model, status: RxStatus.success());
    } catch (error) {
      debugPrint("Dashboard Error: $error");
      _loaded = false; // allow retry on error
      change(null, status: RxStatus.error(error.toString()));
    } finally {
      debugPrint("---------- $apiEndPoint END ----------");
    }
  }

  /// Optional: force refresh (pull-to-refresh etc.)
  Future<void> refreshDashboard() async {
    _loaded = false;
    await getClientDashboardDetails();
  }
}
