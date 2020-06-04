class NetworkUrl {
  //static String url = "http://192.168.1.104/grocery_list/api";
  static String url = "http://192.168.1.9/mylist/api";
  //static String url = "http://192.168.137.1/grocery_list/api";

  static String getProduct() {
    return "$url/getProduct.php";
  }

  static String getProductCategory() {
    return "$url/getProductWithCategory.php";
  }

  static String getProductRetailer() {
    return "$url/getProductWithRetailer.php";
  }

  static String getProductFavoriteWithoutLogin(String deviceInfo) {
    return "$url/getFavoriteWithoutLogin.php?deviceInfo=$deviceInfo";
  }

  static String getProductCart(String unikID) {
    return "$url/getProductCart.php?unikID=$unikID";
  }

  static String addFavoriteWithoutLogin() {
    return "$url/addFavoriteWithoutLogin.php";
  }

  static String addCart() {
    return "$url/addCart.php";
  }

  static String updateQuantity() {
    return "$url/updateQuantityCart.php";
  }

  static String getSummaryAmountCart(String unikID) {
    return "$url/getSumAmountCart.php?unikID=$unikID";
  }

  static String getTotalCart(String unikID) {
    return "$url/getTotalCart.php?unikID=$unikID";
  }

}
