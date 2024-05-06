import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Models/tenant_menu_model.dart';
import '../Pages/MenusPage.dart';
import 'package:gtc_mobile/Services/tenant_service.dart';
import 'package:gtc_mobile/Models/tenant_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TenantListWidget extends StatefulWidget {
  @override
  _TenantListWidgetState createState() => _TenantListWidgetState();
}

class _TenantListWidgetState extends State<TenantListWidget> {
  Future<List<TenantModel>>? _futureTenantList;
  Future<List<TenantMenuModel>>? _futureTenantMenuList;
  // final TenantService _tenantService = TenantService();
  List<Map<String, dynamic>> tenantList = [];

  int _pageSize = 3;
  int _currentPage = 1;
  bool _isLoading = false;

  ScrollController _scrollController = ScrollController();

  void loadTenantList() {
    setState(() {
      _futureTenantList = TenantService.getTenantList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadTenantList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _currentPage++;
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> currentPageData =
        tenantList.take(_currentPage * _pageSize).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12, top: 10),
                child: Text(
                  "Tenant",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(211, 36, 43, 1),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: FutureBuilder<List<TenantModel>>(
            future: _futureTenantList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => TenantProfileCard(tenant: snapshot.data![index]),
                );
              } else if (snapshot.hasError) {
                return Center(child: TextButton(
                  onPressed: loadTenantList,
                  child: Text('Error: ${snapshot.error}'),
                ));
              } else {
                return Center(child: CircularProgressIndicator());
              }
          
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Center(child: CircularProgressIndicator());
              // } else if (snapshot.hasError) {
              //   return Center(child: Text('Error: ${snapshot.error}'));
              // } else {
              //   tenantList = snapshot.data ?? [];
              //   return Row(
              //     children: [
              //       ...currentPageData.map((tenant) {
              //         return GestureDetector(
              //           onTap: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => MenusPage(),
              //               ),
              //             );
              //           },
              //           child: Container(
              //             margin: EdgeInsets.symmetric(
              //                 horizontal: 25, vertical: 10),
              //             height: 100,
              //             width: 100,
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(10),
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: Colors.grey.withOpacity(0.5),
              //                   spreadRadius: 1,
              //                   blurRadius: 6,
              //                 ),
              //               ],
              //             ),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Padding(
              //                   padding: EdgeInsets.all(5),
                                // child: ClipRRect(
                                //   borderRadius: BorderRadius.circular(10),
                                //   child: Image.network(
                                //     tenant["profileTenant"],
                                //     height: 50,
                                //     width: 50,
                                //   ),
                                // ),
              //                 ),
              //                 Padding(
              //                   padding: EdgeInsets.only(top: 5),
              //                   child: Text(
              //                     tenant["namaTenant"],
              //                     style: GoogleFonts.poppins(
              //                       fontSize: 13,
              //                       fontWeight: FontWeight.w600,
              //                       color: Color.fromRGBO(202, 37, 37, 1),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       }).toList(),
              //     ],
              //   );
              // }
            },
          ),
        ),
      ],
    );
  }

  // Future<List<Map<String, dynamic>>> _loadTenantData() async {
  //   final tenantNames = await TenantService.fetchTenantList();

  //   List<Map<String, dynamic>> tenantData = [];
  //   for (var tenant in tenantNames) {
  //     final menuData = await TenantService.fetchMenuByTenant(tenant['namaTenant']);
  //     tenantData.add({
  //       'namaTenant': menuData['namaTenant'],
  //       'profileTenant': menuData['fotoProduk'] ?? '', // Use null-aware operator to handle null values
  //       'namaProduk': menuData['namaProduk'] ?? '', // Add this line
  //       'hargaProduk': menuData['hargaProduk'] ?? '', // Add this line
  //     });
  //   }

  //   return tenantData;
  // }
}

class TenantProfileCard extends StatefulWidget {
  const TenantProfileCard({
    super.key,
    required this.tenant,
  });

  final TenantModel tenant;

  @override
  State<TenantProfileCard> createState() => _TenantProfileCardState();
}

class _TenantProfileCardState extends State<TenantProfileCard> {
  Future<List<TenantMenuModel>>? _futureTenantMenuList;

  void loadTenantMenuList(String nama_tenant) {
    setState(() {
      _futureTenantMenuList = TenantService.getTenantMenuList(nama_tenant);
    });
  }

  @override
  void initState(){
    super.initState();
    loadTenantMenuList(widget.tenant.nama_tenant);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card.filled(
        color: Colors.white,
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<List<TenantMenuModel>>(
              future: _futureTenantMenuList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      height: 100,
                                      fit: BoxFit.cover,
                                      dotenv.env['API_URL']! + "/file/" + snapshot.data![0].fotoProduk,
                                    ),
                                  ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: TextButton(
                    onPressed: () => loadTenantMenuList(widget.tenant.nama_tenant),
                    child: Text('Error: ${snapshot.error}'),
                  ));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Text(widget.tenant.nama_tenant, textAlign: TextAlign.center,),
          ],
        )
      ),
    );
  }
}
