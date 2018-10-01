import 'package:flutter/material.dart';
import 'package:tab_maker/screens/components/shared_components.dart';

class AutoValidatedField extends StatefulWidget {

  final InputDecoration decoration;
  final bool enabled, autoFocus, autoLostFocus;
  final FormFieldSetter<String> onSave;
  final FormFieldValidator<String> _validator;
  final String initialValue, label, hintText;
  final TextInputType keyboardType;
  VoidCallback onFocusChanged;
  final int maxLines;

  AutoValidatedField(
    this._validator,
    {
      Key key, 
      this.onSave,
      this.decoration,
      this.initialValue,
      this.maxLines = 1,
      this.label = "",
      this.hintText = "",
      this.enabled = true,
      this.autoFocus = false,
      this.autoLostFocus = false,
      this.keyboardType = TextInputType.text,
      this.onFocusChanged
    }) : super(key: key);


  @override
  _State createState() => new _State();
}

class _State extends State<AutoValidatedField>{

  TextEditingController _controller = TextEditingController();

  @override
    void initState() {
      super.initState();
      
    }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.initialValue==""?_controller.text:widget.initialValue;
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              padding: new EdgeInsets.only(bottom:widget.label==""?0.0:10.0),
              child: leftAlignedSection([
                widget.label==""?Container():
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800
                  ),
                )
              ]),
            ),
            Container(
              margin: new EdgeInsets.only(bottom: widget.label==""?10.0:0.0),
              child: _mainField(context),
            ),
          ],
        ),
      ],
    );
    
  }

  Widget _mainField(context) {
    FocusNode focusNode = new FocusNode();
    if(widget.autoFocus) FocusScope.of(context).requestFocus(focusNode);
    focusNode.addListener((){ _onFocusChange(focusNode); });
    return TextFormField(
      controller: _controller,
      maxLines: widget.maxLines,
      validator: (val) => widget._validator(val),
      onSaved: (val) => widget.onSave(val),
      focusNode: focusNode,
      style: TextStyle(fontWeight: FontWeight.w400, color: Color.fromRGBO(88, 88, 88, 1.0)),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(192,192,192,0.5),
            width: 1.0,
            style: BorderStyle.solid
          )
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: widget.hintText,
        hintStyle: TextStyle(fontWeight: FontWeight.w100)
      ),
      enabled: widget.enabled,
      obscureText: false,
      keyboardType: widget.keyboardType,
    );
  }

  void _onFocusChange(FocusNode focusNode){
    if(widget.autoLostFocus && focusNode.hasFocus){
      focusNode.unfocus();
      widget.onFocusChanged();
    }
  }

  String get getValue => _controller.value.toString();

}