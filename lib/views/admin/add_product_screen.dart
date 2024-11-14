import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';
import 'package:img_picker/img_picker.dart'; // For file handling

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller for text fields
  final TextEditingController _tenSPController = TextEditingController();
  final TextEditingController _giaSPController = TextEditingController();
  final TextEditingController _motaController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _idDanhMucController = TextEditingController();


  // Function to submit the form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the data
      print("Product added!");
      print("Name: ${_tenSPController.text}");
      print("Price: ${_giaSPController.text}");
      print("Description: ${_motaController.text}");
      print("Discount: ${_discountController.text}");
      print("Category ID: ${_idDanhMucController.text}");

      // Clear fields after submission
      _tenSPController.clear();
      _giaSPController.clear();
      _motaController.clear();
      _discountController.clear();
      _idDanhMucController.clear();
    }
  }

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImgXFile;

  selectImgFromCamera() async{
    pickedImgXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() => pickedImgXFile);

  }

  selectImgFromGalery() async{
    pickedImgXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() => pickedImgXFile);

  }

  //show img when pick
  Widget showImgWhenPicked(){
    return Container(
      height: 150,
      width: 240,
      decoration: BoxDecoration(
      image: DecorationImage(
        image: FileImage(
          File(pickedImgXFile!.path),),),
      ),
    );
  }

  showDialogBoxImg(){
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text( "Chọn ảnh sản phẩm",
          style: const TextStyle(color: Colors.blue),
        ),

        children: [
          SimpleDialogOption(
            onPressed: (){  
                selectImgFromCamera();
            },
            child: const Text(
              "Chọn từ camera",
              style: TextStyle(
                color: Colors.black54,

              ),
            ),
          ),
                  SimpleDialogOption(
            onPressed: (){
                selectImgFromGalery();
            },
            child: const Text(
              "Chọn từ thư viện ảnh",
              style: TextStyle(
                color: Colors.black54,

              ),
            ),
          ),
                    SimpleDialogOption(
            onPressed: (){
              Get.back();
            },
            child: const Text(
              "Hủy",
              style: TextStyle(
                color: Colors.red,

              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add Product",
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.add),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Product Name (tensp)
              TextFormField(
                controller: _tenSPController,
                decoration: InputDecoration(labelText: "Tên sản phẩm"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên sản phẩm';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // anh san pham
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh bên trái
                children: [
                  Text(
                    'Chọn ảnh sản phẩm', // Văn bản "Chọn ảnh sản phẩm"
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Màu xám cho văn bản
                    ),
                  ),
                  SizedBox(height: 16), // Khoảng cách giữa Text và TextButton
                  TextButton.icon(
                    onPressed: () {
                      showDialogBoxImg();
                    },
                    icon: Icon(
                      Icons.image, // Thêm icon hình ảnh (có thể thay đổi bằng bất kỳ icon nào khác)
                      color: Colors.blue, // Màu sắc của icon
                    ),
                    label: Text(
                      "Chọn ảnh sản phẩm", // Văn bản trên nút
                      style: TextStyle(color: Colors.blue), // Màu chữ trên nút
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding cho nút
                      side: BorderSide(color: Colors.blue, width: 2), // Viền màu xanh
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Bo tròn các góc
                      ),
                      shadowColor: Colors.black.withOpacity(0.2), // Màu bóng
                      elevation: 5, // Độ cao bóng
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.8, // Full width
                height: 250, // Set your desired height for the background image area
                decoration: BoxDecoration(
                  image: pickedImgXFile != null // Check if the image is picked
                      ? DecorationImage(
                          image: FileImage(File(pickedImgXFile!.path)),
                          fit: BoxFit.cover, // Make the image cover the container area
                        )
                      : null, // If no image, don't show background
                ),
              ),        
              SizedBox(height: 16),

              // Product Price (giasp)
              TextFormField(
                controller: _giaSPController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Giá"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng chọn kiểu giá trị là số';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Product Description (mota)
              TextFormField(
                controller: _motaController,
                decoration: InputDecoration(labelText: "Mô tả"),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Product Discount (discount)
              TextFormField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Giảm giá (%)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã giảm giá';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Product Category ID (id_danhmuc)
              TextFormField(
                controller: _idDanhMucController,
                decoration: InputDecoration(labelText: "Danh mục"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn danh mục';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              
              // Submit Button
             ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                "Thêm sản phẩm", 
                style: TextStyle(color: Colors.white), // Màu chữ trắng
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Màu nền nút (blue)
                side: BorderSide(color: Colors.white, width: 2), // Viền màu trắng
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32), // Bo tròn các góc
                ),
                elevation: 5, // Độ cao bóng đổ
                shadowColor: Colors.black.withOpacity(0.2), // Màu bóng đổ
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              ),
            ),

            ],
          ),
        ),
      ),
    );
  }
}
