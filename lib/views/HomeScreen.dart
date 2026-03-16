import 'package:flutter/material.dart';
import 'package:mini_app/Components/Product.dart';
import 'package:mini_app/Model/Product_Model.dart';
import 'package:mini_app/Services/ApiService.dart';
import 'package:mini_app/views/CartScree.dart';
import 'package:mini_app/views/Prodcut_Detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  //kutular için ürünler
  bool isloading = false;
  String eror_Message = "";
  List<Data> allProdcut = [];
  Apiservice apiservice = Apiservice();
  //ürün detay
  final Set<int> cartIds = {};
  //Searh
  String searchQuaryy = "";

  @override
  void initState() {
    loadProduct();

    super.initState();
  }

  Future<void> loadProduct() async {
    try {
      setState(() {
        isloading = true;
      });

      Product_Model ReData = await apiservice.fetchProducts();

      setState(() {
        allProdcut = ReData.data ?? [];
      });
    } catch (e) {
      setState(() {
        eror_Message = "Failed to upload product!!";
      });
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProduct = allProdcut.where((product) {
      final name = product.name ?? "";
      return name.toLowerCase().contains(searchQuaryy.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 201, 201),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discover",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              cartscreen(products: allProdcut, cartId: cartIds),
                        ),
                      );
                    },
                    iconSize: 35,
                    icon: Icon(Icons.shopping_bag_outlined),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Text(
                "Find Your Future Devices;",
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),

              SizedBox(height: 14),
              //Arama kısmı Kutusu
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 157, 156, 156),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search Product",
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 37, 37, 37),
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuaryy = value;
                    });
                  },
                ),
              ),
              //Reklam Kısmı
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://wantapi.com/assets/banner.png",
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

              // Ürünler kısmı
              SizedBox(height: 16),
              if (isloading)
                Center(child: CircularProgressIndicator())
              else if (eror_Message.isNotEmpty)
                Center(child: Text(eror_Message))
              else
                Expanded(
                  child: GridView.builder(
                    itemCount: filteredProduct.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProduct[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdcutDetail(
                                product: product,
                                cartIds: cartIds,
                              ),
                            ),
                          );
                        },
                        child: prodcutcart(product: product),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
