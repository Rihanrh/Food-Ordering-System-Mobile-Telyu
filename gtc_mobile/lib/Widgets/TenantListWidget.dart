import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Models/TenantMenuModel.dart';
import 'package:gtc_mobile/Services/TenantService.dart';
import 'package:gtc_mobile/Models/TenantModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TenantListWidget extends StatefulWidget {
  @override
  _TenantListWidgetState createState() => _TenantListWidgetState();
}

class _TenantListWidgetState extends State<TenantListWidget> {
  Future<List<TenantModel>>? _futureTenantList;
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
                  "Tenant Kami",
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
            },
          ),
        ),
      ],
    );
  }
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

  void loadTenantMenuList(int idTenant) {
    setState(() {
      _futureTenantMenuList = TenantService.getTenantMenuList(idTenant);
    });
  }

  @override
  void initState(){
    super.initState();
    loadTenantMenuList(widget.tenant.id);
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
                    onPressed: () => loadTenantMenuList(widget.tenant.id),
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
