// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library editable_label;

import 'dart:html';
import 'package:mdv_observe/mdv_observe.dart';
import 'package:web_ui/web_ui.dart';

/**
 * Label whose [value] can be edited by double clicking. When editing, it
 * displays a form and input element, otherwise it displays the label.
 */
class EditableLabel extends PolymerElement with ObservableMixin {
  @observable bool editing = false;
  @observable String value = '';

  // TODO(jmesserly): replace this with allowing not-operator in templates.
  bool get notEditing => !editing;

  InputElement get _editBox => getShadowRoot("editable-label").query('#edit');

  void created() {
    super.created();

    bindProperty(this, const Symbol('editing'),
        () => notifyProperty(this, const Symbol('notEditing')));
  }

  void edit() {
    editing = true;

    // This causes _editBox to be inserted.
    deliverChangeRecords();

    // For IE and Firefox: use .focus(), then reset the value to move the
    // cursor to the end.
    _editBox.focus();
    _editBox.value = '';
    _editBox.value = value;
  }

  void update(Event e) {
    e.preventDefault(); // don't submit the form
    if (!editing) return; // bail if user canceled
    value = _editBox.value;
    editing = false;
  }

  void maybeCancel(KeyEvent e) {
    if (e.keyCode == KeyCode.ESC) {
      editing = false;
    }
  }
}
