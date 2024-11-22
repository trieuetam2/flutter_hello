import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/admin/addProductController.dart';
import 'package:flutter_application_1/models/sanpham.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
  final TextEditingController _anhSPController = TextEditingController();
  final TextEditingController _giaSPController = TextEditingController();
  final TextEditingController _motaController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _soluongController = TextEditingController();
  final TextEditingController _idDanhMucController = TextEditingController();

  final Addproductcontroller _addProduct = Get.put(Addproductcontroller());

  // Function to submit the form
  void _submitForm() async{
    if (_formKey.currentState!.validate()) {

        //tao moi sanpham
        Sanpham addProductModel = Sanpham(
          1,
          _tenSPController.text.trim(),
          _anhSPController.text.trim(),
          _giaSPController.text.trim(),
          _motaController.text.trim(),
          int.tryParse(_discountController.text.trim()) ?? 0,
          int.tryParse(_soluongController.text.trim()) ?? 0,
          int.tryParse(_idDanhMucController.text.trim()) ?? 0,
        );

        bool addProductsuccess = await _addProduct.addProducts(addProductModel);
        

        if (addProductsuccess) {
          Fluttertoast.showToast(msg: 'Thêm sản phẩm thành công');
          setState(() {
            _tenSPController.clear();
            _giaSPController.clear();
            _motaController.clear();
            _discountController.clear();
            _soluongController.clear();
            _idDanhMucController.clear();

            Get.back(result: true);
          });
        } else {
          Fluttertoast.showToast(msg: 'Thêm sản phẩm thất bại');
        }

    }
  }

  String? imagePath;

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImgXFile;

  selectImgFromCamera() async {
    pickedImgXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() {
      if (pickedImgXFile != null) {
        _saveImage(pickedImgXFile!); // Lưu và cập nhật đường dẫn ảnh
      }
    });
  }

  selectImgFromGallery() async {
    pickedImgXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() {
      if (pickedImgXFile != null) {
        _saveImage(pickedImgXFile!); // Lưu và cập nhật đường dẫn ảnh
      }
    });
  }

 
// Function to save the picked image locally
Future<void> _saveImage(XFile pickedFile) async {
  try {
    // Get the app's document directory to store the image
    final directory = await getApplicationDocumentsDirectory();
    this.imagePath = 'assets/img/img_${DateTime.now().millisecondsSinceEpoch}.jpg'; // Use the global imagePath

    // Copy the image to the new directory
    final File newImage = File(this.imagePath!);
    await pickedFile.saveTo(this.imagePath!);

    // Update the image controller with the new image path
    setState(() {
      _anhSPController.text = this.imagePath!; // Set the image path to controller for uploading (if needed)
    });
  } catch (e) {
    Fluttertoast.showToast(msg: "Failed to save image: $e");
  }
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
                selectImgFromGallery();
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
              "Thêm sản phẩm",
              style: TextStyle(color: Colors.white),
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
          decoration: InputDecoration(
            labelText: "Tên sản phẩm",
            prefixIcon: Icon(Icons.production_quantity_limits), // Icon sản phẩm
          ),
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

        //chọn ảnh sp
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
          decoration: InputDecoration(
            labelText: "Giá",
            prefixIcon: Icon(Icons.attach_money), // Icon giá tiền
          ),
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
          decoration: InputDecoration(
            labelText: "Mô tả",
            prefixIcon: Icon(Icons.description), // Icon mô tả
          ),
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
          decoration: InputDecoration(
            labelText: "Giảm giá (%)",
            prefixIcon: Icon(Icons.discount), // Icon giảm giá
          ),
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

        // Product Soluong (Soluong)
        TextFormField(
          controller: _soluongController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Số lượng",
            prefixIcon: Icon(Icons.numbers), // Icon giảm giá
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập mã giảm giá';
            }
            if (int.tryParse(value) == null) {
              return 'Vui lòng nhập số lượng hợp le';
            }
            return null;
          },
        ),
        SizedBox(height: 16),

        // Product Category ID (id_danhmuc)
        TextFormField(
          controller: _idDanhMucController,
          decoration: InputDecoration(
            labelText: "Danh mục",
            prefixIcon: Icon(Icons.category), // Icon danh mục
          ),
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
