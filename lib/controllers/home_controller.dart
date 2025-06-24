import 'package:get/get.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<ApiResponse?> apiResponse = Rx<ApiResponse?>(null);
  final RxString error = ''.obs;
  final RxBool isOnline = true.obs;

  AppTheme? get theme => apiResponse.value?.data.theme;
  List<ContentItem> get contents => apiResponse.value?.data.contents ?? [];

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Check API reachability first
      final isReachable = await ApiService.isApiReachable();
      isOnline.value = isReachable;

      if (!isReachable) {
        error.value =
            'Unable to reach API server. Please check your internet connection.';
        return;
      }

      final response = await ApiService.fetchAppData();

      if (response != null) {
        apiResponse.value = response;
      } else {
        error.value = 'Failed to load data from API server';
      }
    } catch (e) {
      error.value = 'Network error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  /// Check if we have video reviews content
  bool get hasVideoReviews {
    return contents.any((item) => item.type == 'VIDEO_REVIEWS');
  }

  /// Get API connection status
  String get connectionStatus {
    if (isLoading.value) return 'Connecting to API...';
    if (!isOnline.value) return 'API Offline';
    if (error.value.isNotEmpty) return 'API Error';
    if (contents.isEmpty) return 'No Data';
    return 'API Connected ✅';
  }
}
