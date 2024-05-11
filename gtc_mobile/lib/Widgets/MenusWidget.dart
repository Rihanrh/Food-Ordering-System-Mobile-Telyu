import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Models/TenantMenuModel.dart';
import 'package:gtc_mobile/Services/TenantService.dart';
import 'package:gtc_mobile/Models/TenantModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MenusWidget extends StatefulWidget {
  @override
  _MenusWidgetState createState() => _MenusWidgetState();
}

class _MenusWidgetState extends State<MenusWidget> {
  Future<List<TenantModel>>? _futureTenantList;

  void loadTenantList() {
    setState(() {
      _futureTenantList = TenantService.getTenantList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadTenantList();
  }

  @override
  Widget build(BuildContext context) {
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
                  "Daftar Menu",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(211, 36, 43, 1),
                  ),
                ),
              )
            ],
          ),
        ),
        FutureBuilder<List<TenantModel>>(
          future: _futureTenantList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: 1000.0,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 22, top: 8, bottom: 10),
                        child: Text(
                          snapshot.data![index].nama_tenant,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(126, 0, 0, 1),
                          ),
                        ),
                      ),
                      TenantMenuCard(tenant: snapshot.data![index]),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: TextButton(
                  onPressed: loadTenantList,
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}

class TenantMenuCard extends StatefulWidget {
  const TenantMenuCard({
    super.key,
    required this.tenant,
  });

  final TenantModel tenant;

  @override
  State<TenantMenuCard> createState() => _TenantMenuCardState();
}

class _TenantMenuCardState extends State<TenantMenuCard> {
  Future<List<TenantMenuModel>>? _futureTenantMenuList;

  void loadTenantMenuList(String nama_tenant) {
    setState(() {
      _futureTenantMenuList = TenantService.getTenantMenuList(nama_tenant);
    });
  }

  @override
  void initState() {
    super.initState();
    loadTenantMenuList(widget.tenant.nama_tenant);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TenantMenuModel>>(
      future: _futureTenantMenuList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  height: 120,
                  width: 300,
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
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            dotenv.env['API_URL']! + "/file/" + item.fotoProduk,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 5, top: 30),
                            child: Text(
                              item.namaProduk,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(202, 37, 37, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 5),
                            child: Text(
                              item.hargaProduk.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                    color: Color.fromRGBO(211, 36, 43, 1)),
                                onPressed: () {},
                              ),
                              Text(
                                "0",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Color.fromRGBO(211, 36, 43, 1),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
