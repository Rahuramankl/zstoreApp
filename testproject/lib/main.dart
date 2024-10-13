import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testproject/testing_page/custom_bottomsheet.dart';
import 'package:testproject/zpages/zstore_data.dart';
import 'package:testproject/zpages/zstore_viewmodel.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Zstore'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final DataViewModel viewModel = DataViewModel();
  List<Categories> categories = [];
  TabController? _tabController;
  bool isLoading = true;
  GlobalKey _fabKey = GlobalKey();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await viewModel.loadData();
      setState(() {
        categories = viewModel.data!.categories;
        if (categories.isNotEmpty) {
          _tabController =
              TabController(length: categories.length, vsync: this);
          _tabController?.addListener(() {
            if (!(_tabController?.indexIsChanging ?? true)) {
              print('Tab is selected: ${_tabController?.index}');
            }
          });
        }
        isLoading = false;
      });
    });

  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: _isSearching
              ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(
                  50), // Adjust the radius as needed
            ),
            child: Row(
              children: [
                /*SvgPicture.asset(
                  'assets/Accessory.svg',
                  width: 30,
                  height: 30,
                ),*/
                Icon(Icons.search,color: Colors.black),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black87),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                ),
              ],
            ),
          )
              : Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    child: /*SvgPicture.asset(
                      'assets/Accessory.svg',
                      width: 30,
                      height: 30,
                    )*/Icon(Icons.search,color: Colors.black,),
                  ),
                ),
              ),
            ],
          ),
          actions: _isSearching
              ? [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            ),
          ]
              : [],

          backgroundColor: Colors.white,
          bottom: categories.isNotEmpty
              ? PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Expanded(
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    _tabController?.addListener(() {
                      if (!(_tabController?.indexIsChanging ?? true)) {
                        setState(
                                () {}); // Call setState to update the UI when the tab index changes
                      }
                    });
                    return TabBar(
                      dividerColor: Colors.white,
                      controller: _tabController,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        // Custom BoxDecoration to remove the underline
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.transparent,
                            // Set to transparent to remove the underline
                            width: 0,
                          ),
                        ),
                      ),
                      // Adjust this to TabBarIndicatorSize.label if needed
                      labelColor: Colors.red,
                      unselectedLabelColor: Colors.black87,
                      tabs: List<Widget>.generate(categories.length,
                              (int index) {
                            return Container(
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: _tabController?.index == index
                                      ? Colors.red
                                      : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              // Ensures padding inside the Tab
                              child: Center(
                                child: Tab(text: categories[index].name),
                              ),
                            );
                          }),
                    );
                  }),
            ),
          )
              : null,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
          controller: _tabController,
          children: categories.map((category) {
            if (category.layout == 'waterfall') {
              return getWaterFallView(category.id);
            } else if (category.layout == 'linear') {
              return getlinearView(category.id);
            } else {
              return Center(child: Text(category.name));
            }
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          key: _fabKey,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: showPopupMenu,
          child:Container(
            height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.teal
              ),
              child: Icon(Icons.add,color: Colors.black,size: 20,)),
        ),
      ),
    );
  }

  Widget getWaterFallView(String id) {
    List<Products> filteredProducts = viewModel.data!.products
        .where((product) => product.categoryId == id)
        .toList();
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: filteredProducts.length,
      itemBuilder: (BuildContext context, int index) {
        final product = filteredProducts[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: product.imageUrl == null
                          ? Container(
                          color: Colors.red,
                          height: 100,
                          width: double.infinity)
                          : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          // Adjust the radius as needed
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            height: 100,
                            width: double.infinity,
                          ),
                        ),
                      )),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        // Handle favorite button tap
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text(product.rating.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Expanded(
                          child: RatingBar.builder(
                            itemSize: 10,
                            initialRating: product.rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.red,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                        Text("(" + product.reviewCount.toString() + ")",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.currency_rupee_rounded,
                          size: 16,
                        ),
                        Text(product.price.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Text(product.description.toString()),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.favorite_border),
                            SizedBox(width: 4),
                            Text("Add to Fav"),
                          ],
                        ),
                        onTap: () {
                          // Handle your onTap here
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget getlinearView(String id) {
    List<Products> filteredProducts = viewModel.data!.products
        .where((product) => product.categoryId == id)
        .toList();
    List<Card_offers> filteredCardOffer = viewModel.data!.card_offers.toList();
    bool isSelected = false;
    String isSelectedName = "";
    // Define a list of colors
    final List<Color> cardColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      // Add more colors if needed
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: Colors.orange,
                      ),
                      Text(
                        "Offers",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  )),
            ),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130, // Set a fixed height for the container
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredCardOffer.length,
                      itemBuilder: (context, index) {
                        final card = filteredCardOffer[index];
                        // Get the color for the current card
                        final cardColor = cardColors[index % cardColors.length];

                        return Container(
                          width: 300, // Set a fixed width for each card
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            // Set the border radius for the container
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isSelected = true;
                                  isSelectedName = card.cardName;
                                });
                                print(card.id);
                                print(isSelectedName);
                                print(isSelected);
                              },
                              child: Card(
                                color: cardColor,
                                // Set the card's background color
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(card.cardName,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16)),
                                            // Adjust text color if needed
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(card.offerDesc,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            // Adjust text color if needed
                                            SizedBox(height: 5),
                                            Text(card.maxDiscount,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18)),
                                            // Adjust text color if needed
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 60,
                                        // Set the width for the image container
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          // Set the border radius for the image container
                                          child: Image.network(
                                            card.imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: isSelected,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        // Set the border color to blue
                        borderRadius: BorderRadius.circular(
                            50), // Match the border radius of the InputChip
                      ),
                      child: InputChip(
                        label: Text(isSelected
                            ? "Applied: $isSelectedName"
                            : "No Offer Selected"),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50), // Adjust the radius as needed
                        ),
                        deleteIcon: Icon(Icons.close),
                        // The close icon
                        onDeleted: () {
                          setState(() {
                            isSelected = false;
                            isSelectedName = "";
                          });
                        },
                        onSelected: (bool selected) {
                          // Handle the selection state change if needed
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Container(
            child: filteredProducts.isEmpty
                ? Center(
              child: Text(
                'No Data Found',
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                height: 100,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name,
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      product.rating.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    Expanded(
                                      child: RatingBar.builder(
                                        itemSize: 10,
                                        initialRating: product.rating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.red,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                    ),
                                    Text(
                                      "(${product.reviewCount})",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.currency_rupee_rounded,
                                        size: 16),
                                    Text(
                                      product.price.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(product.description),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showPopupMenu() {
    final RenderBox renderBox =
    _fabKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy - 150, // Adjust this to move the menu up or down
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height,
      ),
      items: [
        PopupMenuItem<int>(
          padding: EdgeInsets.zero,
          value: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            // Set the border radius for the container
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the popup
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Filter Order: From Top to Bottom",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Divider(thickness: 1),
                  InkWell(
                    onTap: () {
                      var home = HomeScreen();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => home),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.star_border_outlined, color: Colors.orangeAccent),
                          SizedBox(width: 8),
                          Text("Rating"),
                          Spacer(),
                          Icon(Icons.circle_outlined),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.paid_rounded, color: Colors.orangeAccent),
                        SizedBox(width: 8),
                        Text("Pricing"),
                        Spacer(),
                        Icon(Icons.circle_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
