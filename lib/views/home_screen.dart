import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../controllers/home_controller.dart';
import '../models/api_response.dart';
import '../utils/app_colors.dart';
import '../widgets/simple_video_player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'API Connection Error',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.error.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.refreshData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry API Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D6B),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Status: ${controller.connectionStatus}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.contents.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildMainContent(controller),
                _buildContentList(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.link, color: Colors.black),
          onPressed: () {},
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.fullscreen, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMainContent(HomeController controller) {
    final topVideoContent = controller.contents.firstWhereOrNull(
      (item) => item.type == 'CAP_TOP_VIDEO',
    );

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topVideoContent != null) _buildMainVideoSection(topVideoContent),
        ],
      ),
    );
  }

  Widget _buildMainVideoSection(ContentItem content) {
    final mediaItem = content.item as MediaItem;

    return Container(
      width: double.infinity,
      height: 220,
      child: SimpleVideoPlayer(
        videoUrl: mediaItem.url,
        thumbnailUrl: mediaItem.thumbnailUrl,
        height: 220,
        width: double.infinity,
        isCircular: false,
      ),
    );
  }

  Widget _buildCertificationBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCertificationBadge('FDA approved', Icons.verified_user),
        _buildCertificationBadge('FSSAI Certified', Icons.verified),
        _buildCertificationBadge('GMP', Icons.verified_outlined),
      ],
    );
  }

  Widget _buildCertificationBadge(String title, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Postpartum Nutrition',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'During the postpartum period, a mother\'s body undergoes significant changes as it recovers from childbirth and adjusts to the demands of breastfeeding. Proper nutrition during this time is crucial to promote recovery, healing, breastfeeding success, reducing risk of postpartum complications & long term health outcomes',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildShopNowButton() {
    return Container(
      width: 120,
      height: 40,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primaryGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Shop Now',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildContentList(HomeController controller) {
    return Column(
      children: controller.contents.map((content) {
        switch (content.type) {
          case 'CAP_TOP_VIDEO':
            return const SizedBox.shrink();
          case 'CAP_IMAGE':
            return _buildImageContent(content);
          case 'CAP_SIDE_SCROLL':
            return _buildSideScrollContent(content);
          case 'CAP_SLIDES':
            return _buildSlidesContent(content);
          case 'CAP_SINGLE':
            return _buildSingleContent(content);
          case 'VIDEO_REVIEWS':
            return _buildVideoReviewsContent(content);
          default:
            return const SizedBox.shrink();
        }
      }).toList(),
    );
  }

  Widget _buildImageContent(ContentItem content) {
    final mediaItem = content.item as MediaItem;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: mediaItem.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildSideScrollContent(ContentItem content) {
    final scrollableItem = content.item as ScrollableItem;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scrollableItem.title != null || scrollableItem.subTitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (scrollableItem.title != null)
                    Text(
                      scrollableItem.title!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2E7D6B),
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                    ),
                  if (scrollableItem.subTitle != null)
                    Text(
                      scrollableItem.subTitle!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: scrollableItem.contents.length,
              itemBuilder: (context, index) {
                final item = scrollableItem.contents[index];
                return Container(
                  height: 280,
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: item.mediaType == 'VIDEO'
                        ? SimpleVideoPlayer(
                            videoUrl: item.url,
                            thumbnailUrl: item.thumbnailUrl,
                            height: 280,
                            width: 220,
                          )
                        : CachedNetworkImage(
                            imageUrl: item.url,
                            fit: BoxFit.fitHeight,
                            height: 280,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidesContent(ContentItem content) {
    final scrollableItem = content.item as ScrollableItem;
    PageController pageController = PageController();
    ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
      color: scrollableItem.background == 'DARK'
          ? AppColors.lightBackground
          : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scrollableItem.title != null)
            Text(
              scrollableItem.title!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2E7D6B),
                letterSpacing: 0.5,
                height: 1.2,
              ),
            ),
          if (scrollableItem.subTitle != null)
            Text(
              scrollableItem.subTitle!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            height: 600,
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: scrollableItem.contents.length,
                  onPageChanged: (index) {
                    currentPageNotifier.value = index;
                  },
                  itemBuilder: (context, index) {
                    final item = scrollableItem.contents[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: item.mediaType == 'VIDEO'
                            ? SimpleVideoPlayer(
                                videoUrl: item.url,
                                thumbnailUrl: item.thumbnailUrl,
                                height: 400,
                                width: double.infinity,
                              )
                            : CachedNetworkImage(
                                imageUrl: item.url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                      ),
                    );
                  },
                ),
                if (scrollableItem.contents.length > 1)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: ValueListenableBuilder<int>(
                      valueListenable: currentPageNotifier,
                      builder: (context, currentPage, child) {
                        return currentPage > 0
                            ? GestureDetector(
                                onTap: () {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black87,
                                    size: 20,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                if (scrollableItem.contents.length > 1)
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: ValueListenableBuilder<int>(
                      valueListenable: currentPageNotifier,
                      builder: (context, currentPage, child) {
                        return currentPage < scrollableItem.contents.length - 1
                            ? GestureDetector(
                                onTap: () {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black87,
                                    size: 20,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleContent(ContentItem content) {
    final mediaItem = content.item as MediaItem;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mediaItem.title != null || mediaItem.subTitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mediaItem.title != null)
                    Text(
                      mediaItem.title!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2E7D6B),
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                    ),
                  if (mediaItem.subTitle != null)
                    Text(
                      mediaItem.subTitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: mediaItem.mediaType == 'VIDEO'
                ? SimpleVideoPlayer(
                    videoUrl: mediaItem.url,
                    thumbnailUrl: mediaItem.thumbnailUrl,
                    height: 300,
                    width: double.infinity,
                  )
                : CachedNetworkImage(
                    imageUrl: mediaItem.url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoReviewsContent(ContentItem content) {
    final videoReviewsItem = content.item as VideoReviewsItem;

    return VideoReviewsSection(videoReviewsItem: videoReviewsItem);
  }
}

class VideoReviewsSection extends StatefulWidget {
  final VideoReviewsItem videoReviewsItem;

  const VideoReviewsSection({
    Key? key,
    required this.videoReviewsItem,
  }) : super(key: key);

  @override
  State<VideoReviewsSection> createState() => _VideoReviewsSectionState();
}

class _VideoReviewsSectionState extends State<VideoReviewsSection> {
  int _currentVisibleIndex = 0;
  final Map<int, double> _visibilityMap = {};

  void _onVisibilityChanged(int index, VisibilityInfo info) {
    _visibilityMap[index] = info.visibleFraction;

    int mostVisibleIndex = 0;
    double maxVisibility = 0.0;

    _visibilityMap.forEach((key, value) {
      if (value > maxVisibility) {
        maxVisibility = value;
        mostVisibleIndex = key;
      }
    });

    if (mostVisibleIndex != _currentVisibleIndex && maxVisibility > 0.8) {
      setState(() {
        _currentVisibleIndex = mostVisibleIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.videoReviewsItem.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.videoReviewsItem.title!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E7D6B),
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.videoReviewsItem.videoReviews.length,
              itemBuilder: (context, index) {
                final review = widget.videoReviewsItem.videoReviews[index];
                final isVisible = index == _currentVisibleIndex;

                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 12),
                  child: VisibilityDetector(
                    key: Key('video_$index'),
                    onVisibilityChanged: (info) =>
                        _onVisibilityChanged(index, info),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SimpleVideoPlayer(
                        videoUrl: review.url,
                        thumbnailUrl: review.thumbnailUrl,
                        height: 320,
                        width: 280,
                        shouldPlay: isVisible,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
