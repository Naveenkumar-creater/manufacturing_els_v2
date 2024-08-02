import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/edit_entry_entity.dart';

class EditEntryProvider extends ChangeNotifier{
  EditEntryEntity ? _editEntry;
  EditEntryEntity ? get  editEntry =>_editEntry;
 void setUser(EditEntryEntity edit){
_editEntry=edit;
notifyListeners();
 }
}