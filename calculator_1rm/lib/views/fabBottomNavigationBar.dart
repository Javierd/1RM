import 'package:flutter/material.dart';

class FABBottomNavigationBarItem{
  IconData icon;
  String title;

  FABBottomNavigationBarItem({this.icon, this.title});
}

class FABBottomNavigationBar extends StatefulWidget{
  final List<FABBottomNavigationBarItem> items;
  final ValueChanged<int> onTap;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final NotchedShape notchedShape;
  final double iconSize;
  final double height;
  final int currentIndex;

  FABBottomNavigationBar({@required this.onTap,
    @required this.items,
    this.backgroundColor: Colors.white,
    @required this.unselectedItemColor,
    @required this.selectedItemColor,
    this.notchedShape,
    this.iconSize: 24,
    this.height: 60.0,
    this.currentIndex: 0
  });

  @override
  _FABBottomNavigationBarState createState() => _FABBottomNavigationBarState();
}

class _FABBottomNavigationBarState extends State<FABBottomNavigationBar>{
  int _selectedIndex;

  void _updateIndex(int index){
    widget.onTap(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    this._selectedIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              '',
              style: TextStyle(color: widget.unselectedItemColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    FABBottomNavigationBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedItemColor : widget.unselectedItemColor;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, color: color, size: widget.iconSize),
                Text(
                  item.title,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}