class basicFunction{

  static youtubevideo(String url){
    url = url.replaceAll("https://www.youtube.com/watch?v=", "");
    return url.replaceAll("https://m.youtube.com/watch?v=", "");
  }


}