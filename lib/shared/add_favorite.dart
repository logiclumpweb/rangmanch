import 'package:flutter/material.dart';

class AddFavorite extends StatefulWidget {
  final bool selected;
  final Function(bool)onSelect;
  final int count;
  const AddFavorite({Key? key, required this.selected, required this.onSelect, required this.count}) : super(key: key);

  @override
  State<AddFavorite> createState() => _AddFavoriteState();
}

class _AddFavoriteState extends State<AddFavorite> {

  bool _selected = false;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
    _count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(children:  [
        Icon(_selected?Icons.favorite:Icons.favorite_border, size: 36, color: _selected?Colors.red:Colors.white,),
        Text('$_count', style: const TextStyle(color: Colors.white),),
        SizedBox(height: 4,)
      ],),
      onTap: (){
        setState(() {
          _selected = !_selected;
          _count = _selected?(_count+1):(_count-1);
          widget.onSelect(_selected);
        });
      },
    );
  }
}
