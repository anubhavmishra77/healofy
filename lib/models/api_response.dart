class ApiResponse {
  final String status;
  final AppData data;

  ApiResponse({
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? '',
      data: AppData.fromJson(json['data'] ?? {}),
    );
  }
}

class AppData {
  final AppTheme theme;
  final List<ContentItem> contents;

  AppData({
    required this.theme,
    required this.contents,
  });

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      theme: AppTheme.fromJson(json['theme'] ?? {}),
      contents: (json['contents'] as List<dynamic>? ?? [])
          .map((item) => ContentItem.fromJson(item))
          .toList(),
    );
  }
}

class AppTheme {
  final String backgroundLight;
  final String backgroundDark;
  final String title;
  final String subTitle;
  final String message;
  final String button;

  AppTheme({
    required this.backgroundLight,
    required this.backgroundDark,
    required this.title,
    required this.subTitle,
    required this.message,
    required this.button,
  });

  factory AppTheme.fromJson(Map<String, dynamic> json) {
    return AppTheme(
      backgroundLight: json['backgroundLight'] ?? '#FFFFFF',
      backgroundDark: json['backgroundDark'] ?? '#F4F8F8',
      title: json['title'] ?? '#164445',
      subTitle: json['subTitle'] ?? '#000000',
      message: json['message'] ?? '#262626',
      button: json['button'] ?? '#4F858A',
    );
  }
}

class ContentItem {
  final String type;
  final dynamic item;

  ContentItem({
    required this.type,
    required this.item,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    final type = json['type'] ?? '';
    final itemData = json['item'] ?? {};

    switch (type) {
      case 'CAP_TOP_VIDEO':
      case 'CAP_SINGLE':
        return ContentItem(
          type: type,
          item: MediaItem.fromJson(itemData),
        );
      case 'CAP_IMAGE':
        return ContentItem(
          type: type,
          item: MediaItem.fromJson(itemData),
        );
      case 'CAP_SIDE_SCROLL':
      case 'CAP_SLIDES':
        return ContentItem(
          type: type,
          item: ScrollableItem.fromJson(itemData),
        );
      case 'VIDEO_REVIEWS':
        return ContentItem(
          type: type,
          item: VideoReviewsItem.fromJson(itemData),
        );
      default:
        return ContentItem(
          type: type,
          item: itemData,
        );
    }
  }
}

class MediaItem {
  final String mediaType;
  final String url;
  final String? thumbnailUrl;
  final int height;
  final int width;
  final String? background;
  final String? title;
  final String? subTitle;

  MediaItem({
    required this.mediaType,
    required this.url,
    this.thumbnailUrl,
    required this.height,
    required this.width,
    this.background,
    this.title,
    this.subTitle,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      mediaType: json['mediaType'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
      background: json['background'],
      title: json['title'],
      subTitle: json['subTitle'],
    );
  }
}

class ScrollableItem {
  final String? background;
  final String? title;
  final String? subTitle;
  final List<MediaItem> contents;

  ScrollableItem({
    this.background,
    this.title,
    this.subTitle,
    required this.contents,
  });

  factory ScrollableItem.fromJson(Map<String, dynamic> json) {
    return ScrollableItem(
      background: json['background'],
      title: json['title'],
      subTitle: json['subTitle'],
      contents: (json['contents'] as List<dynamic>? ?? [])
          .map((item) => MediaItem.fromJson(item))
          .toList(),
    );
  }
}

class VideoReviewsItem {
  final String? background;
  final String? title;
  final List<VideoReviewItem> videoReviews;

  VideoReviewsItem({
    this.background,
    this.title,
    required this.videoReviews,
  });

  factory VideoReviewsItem.fromJson(Map<String, dynamic> json) {
    return VideoReviewsItem(
      background: json['background'],
      title: json['title'],
      videoReviews: (json['videoReviews'] as List<dynamic>? ?? [])
          .map((item) => VideoReviewItem.fromJson(item))
          .toList(),
    );
  }
}

class VideoReviewItem {
  final String mediaType;
  final String url;
  final String? thumbnailUrl;
  final int height;
  final int width;
  final String? fullVideoUrl;

  VideoReviewItem({
    required this.mediaType,
    required this.url,
    this.thumbnailUrl,
    required this.height,
    required this.width,
    this.fullVideoUrl,
  });

  factory VideoReviewItem.fromJson(Map<String, dynamic> json) {
    return VideoReviewItem(
      mediaType: json['mediaType'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
      fullVideoUrl: json['fullVideoUrl'],
    );
  }
}
