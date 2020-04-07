import 'package:calculator_1rm/models/moor_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextInputDialog extends StatefulWidget{
  final String title;
  final String hintText;
  final String initText;
  final VoidCallback onCancel;
  final VoidCallback onOk;
  final ValueChanged<String> onInputChanged;

  TextInputDialog({
    this.title,
    this.hintText,
    this.initText,
    @required this.onCancel,
    @required this.onOk,
    this.onInputChanged,
    Key key
  }) : super(key: key);

  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog>{
  TextEditingController _controller;
  bool _okEnabled;

  bool _validString(String string) => string != null && string.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _okEnabled = _validString(widget.initText);
    _controller = TextEditingController(text: widget.initText??"");
    _controller.addListener((){
      bool tmp = _validString(_controller.text);
      if (tmp != _okEnabled){
        setState(() {
          _okEnabled = tmp;
        });
      }
    });

  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('CANCEL'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            widget.onCancel();
          },
        ),
        IgnorePointer(
          ignoring: !_okEnabled,
          child: FlatButton(
            child: const Text('OK'),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textColor: _okEnabled ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
            onPressed: () {
              widget.onOk();
            },
          ),
        ),
      ],
      content: TextField(
        autofocus: true,
        maxLines: 1,
        style: TextStyle(fontSize: 18),
        controller: _controller,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
        ),
        onChanged: (value) {
          if (widget.onInputChanged != null){
            widget.onInputChanged(value);
          }
        },
      ),
    );
  }
}

class SaveRecordDialog extends StatefulWidget{
  final String title;
  final String hintText;
  final VoidCallback onCancel;
  final VoidCallback onOk;
  final ValueChanged<String> onInputChanged;
  final ValueChanged<Exercise> onSelectedOptionChanged;
  final List<Exercise> exercises;

  SaveRecordDialog({
    this.title,
    this.hintText,
    @required this.onCancel,
    @required this.onOk,
    @required this.exercises,
    this.onInputChanged,
    this.onSelectedOptionChanged,
    Key key
  }) : super(key: key);

  @override
  _SaveRecordDialogStatus createState() => _SaveRecordDialogStatus();
}

class _SaveRecordDialogStatus extends State<SaveRecordDialog>{
  Exercise _selected;

  @override
  void initState() {
    super.initState();
    if (widget.exercises != null && widget.exercises.length > 0){
      _selected = widget.exercises[0];
      widget.onSelectedOptionChanged(_selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('CANCEL'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            widget.onCancel();
          },
        ),
        FlatButton(
          child: const Text('OK'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            widget.onOk();
          },
        ),
      ],
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height*0.4,
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.exercises.length,
                  itemBuilder: (BuildContext context, int index){
                    return RadioListTile<Exercise>(
                        title: Text(widget.exercises[index].name),
                        value: widget.exercises[index],
                        groupValue: _selected,
                        onChanged: (value){
                          if (widget.onSelectedOptionChanged != null){
                            widget.onSelectedOptionChanged(value);
                          }
                          setState(() {
                            _selected = value;
                          });
                        }
                    );
                  }
              ),
            ),
            Divider(),
            TextField(
              autofocus: false,
              maxLines: 1,
              style: TextStyle(fontSize: 18),
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
              ),
              onChanged: (value) {
                if (widget.onInputChanged != null){
                  widget.onInputChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}