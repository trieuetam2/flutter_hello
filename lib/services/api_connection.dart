class API{
  static const hostConnection = 'https://192.168.1.14/flutter_api';
  static const hostConnectionUser = '$hostConnection/user';

  //signup user
  static const validateEmail = "$hostConnection/user/validate_email.php";
  static const signUp = "$hostConnection/user/signup.php";
  static const logIn = "$hostConnection/user/login.php";
  static const showClientProduct = "$hostConnection/user/showproduct.php";
  static const showCategory = "$hostConnection/user/showcategory.php";
  static const showDetailProduct = "$hostConnection/user/detailproduct.php";
  static const showCateByID = "$hostConnection/user/showcategorybyid.php";
  
  
  //admin
  //add product
  static const addProduct = "$hostConnection/admin/addproduct.php";
  static const showProduct = "$hostConnection/admin/showproduct.php";
  static const deleteProduct = "$hostConnection/admin/deleteproduct.php";

  //show edit product
  static const showEditProduct = "$hostConnection/admin/showEditProduct.php";
  static const updateProduct = "$hostConnection/admin/updateProduct.php";
  static const searchProduct = "$hostConnection/admin/searchProduct.php";
}