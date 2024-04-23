import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantListWidget extends StatefulWidget {
  @override
  _TenantListWidgetState createState() => _TenantListWidgetState();
}

class _TenantListWidgetState extends State<TenantListWidget> {
  final List<Map<String, dynamic>> tenantList = [
    {"namaTenant": "Rasya", "profileTenant": "assets/tenantListImages/1.jpg"},
    {"namaTenant": "Lili", "profileTenant": "assets/tenantListImages/2.jpg"},
    {"namaTenant": "Idon", "profileTenant": "assets/tenantListImages/3.jpg"},
    {"namaTenant": "Erha", "profileTenant": "assets/tenantListImages/4.jpg"},
    {"namaTenant": "Liyan", "profileTenant": "assets/tenantListImages/5.jpg"},
    {"namaTenant": "Madam", "profileTenant": "assets/tenantListImages/6.jpg"},
    {"namaTenant": "Ren", "profileTenant": "assets/tenantListImages/7.jpg"},
    {"namaTenant": "Caren", "profileTenant": "assets/tenantListImages/8.jpg"},
    {"namaTenant": "Reren", "profileTenant": "assets/tenantListImages/9.jpg"},
  ];

  int _pageSize = 3; 
  int _currentPage = 1; 

  bool _isLoading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMoreData();
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

      // Simulating loading delay
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
    List<Map<String, dynamic>> currentPageData = tenantList
        .take(_currentPage * _pageSize) 
        .toList();

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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: [
                ...currentPageData.map((tenant) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              tenant["profileTenant"],
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            tenant["namaTenant"],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(202, 37, 37, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (_isLoading)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
