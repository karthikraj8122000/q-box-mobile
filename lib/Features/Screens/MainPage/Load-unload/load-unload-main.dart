import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/MainPage/Load-unload/unload-from-qbox.dart';
import 'package:qr_page/Widgets/Common/network_error.dart';

import '../../../../Provider/order/order_qr_scanning_provider.dart';
import '../../../../Widgets/Custom/custom_modern_tabbar.dart';
import '../Order/scan_history_screen.dart';
import 'load-to-qbox.dart';

class LoadOrUnload extends StatefulWidget {
  static const String routeName = '/load-unload';
  const LoadOrUnload({Key? key}) : super(key: key);

  @override
  State<LoadOrUnload> createState() => _LoadOrUnloadState();
}

class _LoadOrUnloadState extends State<LoadOrUnload>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<TabItem> _tabItems;

  @override
  void initState() {
    super.initState();
    _tabItems = [
      TabItem(title: 'Load To QBox', icon: Icons.inbox),
      TabItem(title: 'Unload From QBox', icon: Icons.outbox),
    ];
    _tabController = TabController(length: _tabItems.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return NetworkWrapper(
      child: ChangeNotifierProvider(
        create: (_) => OrderScanningProvider(),
        child: Consumer<OrderScanningProvider>(
          builder: (context, provider, child) => Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text('Load/Unload',
                            style: TextStyle(color: Colors.black)),
                      ),
                      background: Container(color: Colors.grey[100]),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      _buildTabBar(),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  LoadQbox(),
                  UnloadQbox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ModernTabBar(
        controller: _tabController,
        tabItems: _tabItems,
        onTap: (index) {
          print('Tapped on tab $index');
        },
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  double get minExtent => 76.0;
  @override
  double get maxExtent => 76.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
