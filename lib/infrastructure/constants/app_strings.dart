// This class contains all the strings used in the app.
// This is a good practice for managing strings and for localization.
class AppStrings {
  static final String appTitle = 'Wallify';
  static final String setAsHomeScreen = 'Set as Home Screen';
  static final String setAsLockScreen = 'Set as Lock Screen';
  static final String setAsBoth = 'Set as Both';
  static final String wallpaperCategoryScreen = 'WallpaperCategoryScreen is working';
  static final String noFavouriteWallpapers = 'No favourite wallpapers yet!';
  static final String home = 'Home';
  static final String category = 'category';
  static final String favourite = 'Favourite';
  static const String save = 'Save';
  static const String set = 'Set';
  static const String tryAgain = 'Try again';
  static const String failedToLoadWallpapers = 'Failed to load wallpapers.';
  static const String noWallpapersFound = 'No wallpapers found.';
  static const String categories = 'Categories';
  static const String exploreByCategory = 'Explore by category';
  static const String browseWallpapers = 'Browse wallpapers';
  static const String download = 'Download';
  static const String downloadingEllipsis = 'Downloading...';
  static const String cancel = 'Cancel';
  static const String remove = 'Remove';
  static const String resolutionUnavailable = 'Resolution unavailable';
  static const String noInternetConnection = 'No Internet Connection';
  static const String storagePermissionDenied = 'Storage permission denied.';
  static const String wallpaperSavedSuccessfully = 'Wallpaper saved successfully!';
  static const String wallpaperSetSuccessfully = 'Wallpaper set successfully!';
  static const String failedToSaveWallpaper = 'Failed to save wallpaper.';
  static const String failedToSetWallpaper = 'Failed to set wallpaper.';
  static const String noWallpapersSaved = 'No wallpapers saved.';

  static String downloadProgress(int completed, int total) {
    return 'Downloading $completed/$total';
  }

  static String downloadCount(int count) {
    return '$download ($count)';
  }

  static String removeCount(int count) {
    return '$remove ($count)';
  }

  static String savedWallpapers(int count) {
    return 'Saved $count wallpapers.';
  }

  static String wallpaperIndex(int index) {
    return 'Wallpaper $index';
  }

  static const String filterAllLabel = 'All';
  static const String filterAllQuery = '';
  static const String filterAbstractLabel = 'Abstract';
  static const String filterAbstractQuery = 'abstract';
  static const String filterAnimalsLabel = 'Animals';
  static const String filterAnimalsQuery = 'animals';
  static const String filterAnimeLabel = 'Anime';
  static const String filterAnimeQuery = 'anime';
  static const String filterArtLabel = 'Art';
  static const String filterArtQuery = 'art';
  static const String filterBeachLabel = 'Beach';
  static const String filterBeachQuery = 'beach';
  static const String filterBlackWhiteLabel = 'Black & White';
  static const String filterBlackWhiteQuery = 'black and white';
  static const String filterCitiesLabel = 'Cities';
  static const String filterCitiesQuery = 'city';
  static const String filterDarkLabel = 'Dark';
  static const String filterDarkQuery = 'dark';
  static const String filterFantasyLabel = 'Fantasy';
  static const String filterFantasyQuery = 'fantasy';
  static const String filterFashionLabel = 'Fashion';
  static const String filterFashionQuery = 'fashion';
  static const String filterFitnessLabel = 'Fitness';
  static const String filterFitnessQuery = 'fitness';
  static const String filterFoodLabel = 'Food';
  static const String filterFoodQuery = 'food';
  static const String filterHistoryLabel = 'History';
  static const String filterHistoryQuery = 'history';
  static const String filterHotLabel = 'Hot';
  static const String filterHotQuery = 'hot';
  static const String filterInspirationLabel = 'Retro';
  static const String filterInspirationQuery = 'retro';
  static const String filterMountainsLabel = 'Mountains';
  static const String filterMountainsQuery = 'mountains';
  static const String filterMusicLabel = 'Music';
  static const String filterMusicQuery = 'music';
  static const String filterNatureLabel = 'Nature';
  static const String filterNatureQuery = 'nature';
  static const String filterSeaLabel = 'Sea';
  static const String filterSeaQuery = 'sea ocean';
  static const String filterSeasonsLabel = 'Seasons';
  static const String filterSeasonsQuery = 'seasons';
  static const String filterSpaceLabel = 'Space';
  static const String filterSpaceQuery = 'space';
  static const String filterSportsLabel = 'Sports';
  static const String filterSportsQuery = 'sports';
  static const String filterSunLabel = 'Sun';
  static const String filterSunQuery = 'sun';
  static const String filterSunsetLabel = 'Sunset';
  static const String filterSunsetQuery = 'sunset';
  static const String filterTechnologyLabel = 'Technology';
  static const String filterTechnologyQuery = 'technology';
  static const String filterTravelLabel = 'Travel';
  static const String filterTravelQuery = 'travel';
  static const String filterVehiclesLabel = 'Vehicles';
  static const String filterVehiclesQuery = 'vehicles';
  static const String filterVintageLabel = 'Vintage';
  static const String filterVintageQuery = 'vintage';
}
