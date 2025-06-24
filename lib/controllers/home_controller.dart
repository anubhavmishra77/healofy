import 'package:get/get.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<ApiResponse?> apiResponse = Rx<ApiResponse?>(null);
  final RxString error = ''.obs;

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

      final response = await ApiService.fetchAppData();

      if (response != null) {
        apiResponse.value = response;
        print('✅ Data fetched successfully: ${contents.length} items');
      } else {
        error.value = 'Failed to load data';
      }
    } catch (e) {
      error.value = 'Error: $e';
      print('❌ Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchData();
  }
}
