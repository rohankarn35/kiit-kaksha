import 'package:flutter/material.dart';

Widget buildDropdown(
  BuildContext context,
    String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$label",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      SizedBox(height: 8.0),
      Container(
        padding: EdgeInsets.only(left: 40,right: 40,),
        child: DropdownButtonFormField(
          menuMaxHeight: MediaQuery.of(context).size.height / 1.5,
          borderRadius: BorderRadius.circular(10),
          alignment: AlignmentDirectional.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          value: value,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          items: items.map((String item) {
            return DropdownMenuItem(
              child: Container(
                height: 30,
                width: 100, // Adjust the width to your preference
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: value == item ? Colors.green : Colors.grey,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(item, style: TextStyle(color: Colors.white)),
                ),
              ),
              value: item,
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select at least one value.';
            }
            return null;
          },
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}