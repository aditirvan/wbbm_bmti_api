import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wbbm_bmti/Bloc/Account.dart';
import 'package:wbbm_bmti/Event/Account.dart';
import 'package:wbbm_bmti/PDFViewer.dart';
import 'package:wbbm_bmti/Repository/Account.dart';
import 'package:wbbm_bmti/State/Account.dart';
import 'package:wbbm_bmti/SublistMenu.dart';
import 'package:wbbm_bmti/UpdateProfile.dart';

class SublistItem {
  final String icon;
  final String data;
  final String name;
  final int type;

  SublistItem({this.icon, this.data, this.name, this.type});
}

class HomePage extends StatefulWidget {
  final String email;
  final String password;

  const HomePage({Key key, @required this.email, @required this.password})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => AccountBloc(
          FakeAccountRepository(),
        ),
        child: HomePages(
          email: widget.email,
          password: widget.password,
        ),
      ),
    );
  }
}

class HomePages extends StatefulWidget {
  final String email;
  final String password;

  const HomePages({Key key, @required this.email, @required this.password})
      : super(key: key);
  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openVideo() async {
    launchURL(
        "https://www.youtube.com/playlist?list=PLUuLYdiXCItnxHBrNgdmgMVchAPrSAzjT");
  }

  void openDocumentLengkapZIWBK() {
    launchURL("http://gg.gg/wbbmkemdikbud");
  }

  void openWebsiteRBI() {
    launchURL("http://rbibmti.blogspot.com/");
  }

  void openBukuSakuPDF() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewer(
          path: "assets/pdf/buku_saku_compressed.pdf",
        ),
      ),
    );
  }

  void openPDFBukuLengkap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewer(
          path: "assets/pdf/buku-lengkap-wbbm_compressed.pdf",
        ),
      ),
    );
  }

  void openPrezi() {
    List<SublistItem> data = new List<SublistItem>();
    data.add(
      SublistItem(
        name: "PREZI UPPP",
        icon: "assets/image/icon2.jpg",
        data: "https://prezi.com/view/yaBTKBC7mbOZWDCiIx6r",
        type: 2,
      ),
    );
    data.add(
      SublistItem(
        name: "PREZI SIPP",
        icon: "assets/image/icon2.jpg",
        data: "https://prezi.com/view/MqKcIeEEJt8vaIdz9ayn/",
        type: 2,
      ),
    );
    data.add(
      SublistItem(
        name: "PREZI 6 AREA PERUBAHAN",
        icon: "assets/image/icon2.jpg",
        data: "https://prezi.com/view/Q3rIm7HNP8cBHZ0eHLNY",
        type: 2,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SublistMenu(data)),
    );
  }

  void openLeaflet() {
    List<SublistItem> data = new List<SublistItem>();
    data.add(
      SublistItem(
        name: "Leaflet 6 Area Perubahan",
        icon: "assets/image/icon4.jpg",
        data: "assets/image/leaflet6.png",
        type: 0,
      ),
    );
    data.add(
      SublistItem(
        name: "Leaflet SKM",
        icon: "assets/image/icon4.jpg",
        data: "assets/image/Leaflet_SKM-min.jpg",
        type: 0,
      ),
    );
    data.add(
      SublistItem(
        name: "MAKLUMAT LEAFLET",
        icon: "assets/image/icon4.jpg",
        data: "assets/image/MAKLUMAT LEAFLET-min.jpg",
        type: 0,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SublistMenu(data)),
    );
  }

  void otherTap() {}

  void openImageViewerInfoGrafis() {
    List<SublistItem> data = new List<SublistItem>();
    data.add(
      SublistItem(
        name: "Infografis SIPP",
        icon: "assets/image/icon3.jpg",
        data: "assets/pdf/Infografis SIPP_compressed.pdf",
        type: 1,
      ),
    );
    data.add(
      SublistItem(
        name: "Infografis WBBM",
        icon: "assets/image/icon3.jpg",
        data: "assets/pdf/Infografis WBBM Final_bbppmpv_compressed.pdf",
        type: 1,
      ),
    );
    data.add(
      SublistItem(
        name: "Infografis WBBM UPPP",
        icon: "assets/image/icon3.jpg",
        data: "assets/pdf/Infografis WBBM UPPP_compressed.pdf",
        type: 1,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SublistMenu(data)),
    );
  }

  void openHomePage() {
    launchURL("https://p4tkbmti.kemdikbud.go.id");
  }

  void openFacebook() {
    launchURL("https://www.facebook.com/p4tkbmti.kemdikbud");
  }

  void openTwitter() {
    launchURL("https://twitter.com/bmti_kemdikbud");
  }

  void openInstagram() {
    launchURL("https://www.instagram.com/p4tkbmti.kemdikbud");
  }

  void openYoutube() {
    launchURL("https://www.youtube.com/p4tkbmti_kemdikbud");
  }

  void openWhatsapp() {
    launchURL(
        "https://wa.me/628112242326?text=Halo, saya pengguna aplikasi Zi. Ingin berkonsultasi.");
  }

  AccountBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<AccountBloc>(context);
    bloc.add(GetAccount(email: widget.email, password: widget.password));
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {},
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              _buildHeader(context),
              _buildGridView(context),
            ],
          ),
          Container(
            alignment: Alignment(0, 1),
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.only(top: 0),
              height: 85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildBottomNavigation(
                      context, openHomePage, "assets/image/global.png", ""),
                  _buildBottomNavigation(
                      context, openFacebook, "assets/image/facebook.png", ""),
                  _buildBottomNavigation(
                      context, openTwitter, "assets/image/twitter.png", ""),
                  _buildBottomNavigation(
                      context, openInstagram, "assets/image/instagram.png", ""),
                  _buildBottomNavigation(
                      context, openYoutube, "assets/image/youtube.png", ""),
                  _buildBottomNavigation(
                      context, openWhatsapp, "assets/image/whatsapp.png", ""),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBottomNavigation(BuildContext context, void Function() funtion,
      String image, String text) {
    return GestureDetector(
      onTap: funtion,
      child: Image.asset(
        image,
        width: 40,
      ),
    );
  }

  _buildGridView(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16, right: 8, bottom: 8, left: 16),
          child: _buildGridItem(context, openVideo, "assets/image/icon1.jpg"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 8, bottom: 8, left: 16),
          child: _buildGridItem(context, openPrezi, "assets/image/icon2.jpg"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 8, bottom: 8, left: 16),
          child: _buildGridItem(
              context, openImageViewerInfoGrafis, "assets/image/icon3.jpg"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 8, bottom: 8, left: 16),
          child: _buildGridItem(context, openLeaflet, "assets/image/icon4.jpg"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 8, bottom: 8, left: 16),
          child: _buildGridItem(
              context, openPDFBukuLengkap, "assets/image/icon5.jpg"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 8, bottom: 8, left: 16),
          child:
              _buildGridItem(context, openWhatsapp, "assets/image/icon6.jpg"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 8, bottom: 8, left: 16),
          child: _buildGridItem(
              context, openBukuSakuPDF, "assets/image/icon7.png"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 8, bottom: 8, left: 16),
          child: _buildGridItem(
              context, openDocumentLengkapZIWBK, "assets/image/icon8.png"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 8, bottom: 8, left: 16),
          child:
              _buildGridItem(context, openWebsiteRBI, "assets/image/icon9.png"),
        ),
      ],
    );
  }

  _buildHeader(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is AccountLoaded) {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Halo,",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Divider(
                          height: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          "${state.account.name.split(" ")[0]}, ${state.account.tanggalRegistrasi}, ${state.account.perusahaan}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            width: 150,
                            child: InkWell(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8, left: 4.0),
                                    child: Text(
                                      "Update Profile",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateProfile(
                                      email: widget.email,
                                      password: widget.password,
                                    ),
                                  ),
                                );
                                bloc.add(
                                  GetAccount(
                                    email: widget.email,
                                    password: widget.password,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 85.0,
                    height: 85.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new NetworkImage(
                          "http://119.235.16.190/wbbmapi/uploads/${state.account.image}",
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Container(
                  width: 85,
                  height: 85,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                VerticalDivider(),
                Text(
                  "Mengambil Informasi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  _buildGridItem(BuildContext context, void Function() funtion, String image) {
    return GestureDetector(
      onTap: funtion,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        color: Color.fromRGBO(203, 246, 255, 1),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Image.asset(image),
        ),
      ),
    );
  }
}
