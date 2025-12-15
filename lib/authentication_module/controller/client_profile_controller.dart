import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/model/client_profile_model.dart';
import 'package:school_management/utils/dio/api_end_points.dart';
import 'package:school_management/utils/dio/api_request.dart';

class ClientProfileController extends GetxController with StateMixin<ClientProfileModel> {
  RxInt sumit = 0.obs;

  getClientProfile() async {
    const apiEndPoint = APIEndPoints.getClientProfile;

    debugPrint("---------- $apiEndPoint getProfileData Start ----------");
    dynamic response;
    try {
      change(null, status: RxStatus.loading());

      response = await getRequest(apiEndPoint: apiEndPoint);

      debugPrint("ProfileController => getProfileData > Success ${response.data} ");

      final modal = ClientProfileModel.fromJson(response.data);
      change(modal, status: RxStatus.success());
    } catch (error) {
      debugPrint("---------- $apiEndPoint getProfileData End With Error ----------");
      debugPrint("ProfileController => getProfileData > Error $error ");
      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint getProfileData End ----------");
    }

    return response;
  }

  updateValue() {
    sumit.value++;
  }
}

