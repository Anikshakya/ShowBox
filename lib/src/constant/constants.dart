class AppConstants {
  static String apiKey = '75d3652f3aa0c0426d3f5d5e4a1c76c9';
  static String bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NWQzNjUyZjNhYTBjMDQyNmQzZjVkNWU0YTFjNzZjOSIsIm5iZiI6MTczMjI2ODU0My4yNDc2NzE2LCJzdWIiOiI2NzQwMjE4MTMyYTlhYWY0M2Q5Njc5MTgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.0rA91ko0X8u4f1aP3w2dXlvygQlHmfJiBeipLJSr5yE';

  static String baseUrl = 'https://api.themoviedb.org/3';

  // MOVIES
  static String movieListUrl = '$baseUrl/discover/movie';
  static String movieDetailUrl = '$baseUrl/movie';
  static String searchMovieUrl = '$baseUrl/search/movie';

  //SHOWS
  static String showListUrl = '$baseUrl/discover/tv';
  static String showDetailUrl = '$baseUrl/tv';
  static String searchShowUrl = '$baseUrl/search/tv';


  // video embed url
  static String movieEmbedUrl = 'https://vidsrc.xyz/embed/movie';
  static String showEmbedUrl = 'https://vidsrc.xyz/embed/tv';

  //MISC 
  static String posterUrl = 'https://image.tmdb.org/t/p/original';

  // ---------- TRENDING ----------
  static String trendingUrl = '$baseUrl/trending/all/day';
}