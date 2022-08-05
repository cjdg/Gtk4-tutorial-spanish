# Template XML and composite widget

The tfe program in the previous section is not so good because many things are crammed into `tfepplication.c`.
Many static variables in `tfepplication.c` shows that.

~~~C
static GtkDialog *pref;
static GtkFontButton *fontbtn;
static GSettings *settings;
static GtkDialog *alert;
static GtkLabel *lb_alert;
static GtkButton *btn_accept;

static gulong pref_close_request_handler_id = 0;
static gulong alert_close_request_handler_id = 0;
static gboolean is_quit;
~~~

Generally, if there are many global or static variables in the program, it is not a good program.
Such programs are difficult to maintain.

The file `tfeapplication.c` should be divided into several files.

- `tfeapplication.c` only has codes related to GtkApplication.
- A file for GtkApplicationWindow
- A file for a preference dialog
- A file for an alert dialog

The preference dialog is defined by a ui file.
And it has GtkBox, GtkLabel and GtkFontButton in it.
Such widget is called composite widget.
Composite widget is a child object (not child widget) of a widget.
For example, the preference composite widget is a child object of GtkDialog.
Composite widget can be built from template XML.
Next subsection shows how to build a preference dialog.

## Preference dialog

First, write a template XML file.

@@@include
tfe7/tfepref.ui
@@@

- 3: Template tag specifies a composite widget.
The value of a class attribute is the object name of the composite widget.
This XML file names the object "TfePref".
It is defined in a C source file and it will be shown later.
A parent attribute specifies the direct parent object of the composite widget.
`TfePref` is a child object of `GtkDialog`.
Therefore the value of the attribute is "GtkDialog".
A parent attribute is optional but it is recommended to specify.

Other lines are the same as before.
The object `TfePref` is defined in `tfepref.h` and `tfepref.c`.

@@@include
tfe7/tfepref.h
@@@

- 6-7: When you define a new object, you need to write these two lines.
Refer to [Section 8](sec8.src.md).
- 9-10: `tfe_pref_new` creates a new TfePref object.
It has a parameter `win` which is used as a transient parent window to show the dialog.

@@@include
tfe7/tfepref.c
@@@

- 3-8: The structure of an instance of this object.
It has two variables, settings and fontbtn.
- 10: `G_DEFINE_TYPE` macro.
This macro registers the TfePref type.
- 12-18: Dispose handler.
This handler is called when the instance is destroyed.
The destruction process has two stages, disposing and finalizing.
When disposing, the instance releases all the references (to the other instances).
TfePref object holds a reference to the GSettings instance.
It is released in line 16.
After that parents dispose handler is called in line 17.
For further information about destruction process, refer to [Section 11](sec11.src.md).
- 27-34: Class initialization function.
- 31: Set the dispose handler.
- 32: `gtk_widget_class_set_template_from_resource` function associates the description in the XML file (`tfepref.ui`) with the widget.
At this moment no instance is created.
It just make the class to know the structure of the object.
That's why the top level tag is not `<object>` but `<template>` in the XML file.
- 33: `gtk_widget_class_bind_template_child` function binds a private variable of the object with a child object in the template.
This function is a macro.
The name of the private variable (`fontbtn` in line 7) and the id `fontbtn` in the XML file (line 24) must be the same.
The pointer to the instance will be assigned to the variable `fontbtn` when the instance is created.
- 20-25: Instance initialization function.
- 22: Creates the instance based on the template in the class.
The template has been made during the class initialization process.
- 23: Create GSettings instance with the id "com.github.ToshioCP.tfe".
- 24: Bind the font key in the GSettings object to the font property in the GtkFontButton.
- 36-39: The function `tfe_pref_new` creates an instance of TfePref.
The parameter `win` is a transient parent.

Now, It is very simple to use this dialog.
A caller just creates this object and shows it.

~~~C
TfePref *pref;
pref = tfe_pref_new (win) /* win is the top-level window */
gtk_widget_show (GTK_WINDOW (win));
~~~

This instance is automatically destroyed when a user clicks on the close button.
That's all.
If you want to show the dialog again, just create and show it.

## Alert dialog

It is almost same as preference dialog.

Its XML file is:

@@@include
tfe7/tfealert.ui
@@@

The header file is:

@@@include
tfe7/tfealert.h
@@@

There are three public functions.
The functions `tfe_alert_set_message` and `tfe_alert_set_button_label` sets the label and button name of the alert dialog.
For example, if you want to show an alert that the user tries to close without saving the content, set them like:

~~~C
tfe_alert_set_message (alert, "Are you really close without saving?"); /* alert points to a TfeAlert instance */
tfe_alert_set_button_label (alert, "Close");
~~~

The function `tfe_alert_new` creates a TfeAlert dialog.

The C source file is:

@@@include
tfe7/tfealert.c
@@@

The program is almost same as `tfepref.c`.

The instruction how to use this object is as follows.

1. Write a "response" signal handler.
2. Create a TfeAlert object.
3. Connect "response" signal to a handler
4. Show the dialog
5. In the signal handler, do something with regard to the response-id.
Then destroy the dialog.

## Top-level window

In the same way, create a child object of GtkApplicationWindow.
The object name is "TfeWindow".

@@@include
tfe7/tfewindow.ui
@@@

This XML file is almost same as before except template tag and "action-name" property in buttons.

GtkButton implements GtkActionable interface, which has "action-name" property.
If this property is set, GtkButton activates the action when it is clicked.
For example, if an open button is clicked, "win.open" action will be activated and `open_activated` handler will be invoked.

This action is also used by "\<Control\>o" accelerator (See the source code of `tfewindow.c` below).
If you use "clicked" signal for the button, you need its signal handler.
Then, there are two handlers:

- a handler for the "clicked" signal on the button
- a handler for the "activate" signal on the "win.open" action, to which "\<Control\>o" accelerator is connected

These two handlers do almost same thing.
It is inefficient.
Connecting buttons to actions is a good way to reduce unnecessary codes.


@@@include
tfe7/tfewindow.h
@@@

There are three public functions.
The function `tfe_window_notebook_page_new` creates a new notebook page.
This is a wrapper function for `notebook_page_new`.
It is called by GtkApplication object.
The function `tfe_window_notebook_page_new_with_files` creates notebook pages with a contents read from the given files.
The function `tfe_window_new` creates a TfeWindow instance.

@@@include
tfe7/tfewindow.c
@@@

- 17-29: `alert_response_cb` is a call back function of the "response" signal of TfeAlert dialog.
This is the same as before except `gtk_window_destroy(GTK_WINDOW (win))` is used instead of `tfe_application_quit`.
- 31-102: Handlers of action activated signal.
The `user_data` is a pointer to TfeWindow instance.
- 104-115: A handler of "changed::font" signal of GSettings object.
- 111: Gets the font from GSettings data.
- 112: Gets a PangoFontDescription from the font.
In the previous version, the program gets the font description from the GtkFontButton.
The button data and GSettings data are the same.
Therefore, the data got here is the same as the data in the GtkFontButton.
In addition, we don't need to worry about the preference dialog is alive or not thanks to the GSettings.
- 114: Sets CSS on the display with the font description.
- 117-132: Public functions.
- 134-141: Dispose handler.
The GSettings object needs to be released.
- 143-171: Instance initialization function.
- 148: Creates a composite widget instance with the template.
- 151-153: Insert `menu` to the menu button.
- 155-156: Creates a GSettings instance with the id "com.github.ToshioCP.tfe".
Connects "changed::font" signal to the handler `changed_font_cb`.
This signal emits when the GSettings data is changed.
The second part "font" of the signal name "changed::font" is called details.
Signals can have details.
If a GSettings instance has more than one key, "changed" signal emits only if the key, which has the same name as the detail, changes its value.
For example, Suppose a GSettings object has three keys "a", "b" and "c".
  - "changed::a" is emitted when the value of the key "a" is changed. It isn't emitted when the value of "b" or "c" is changed.
  - "changed::b" is emitted when the value of the key "b" is changed. It isn't emitted when the value of "a" or "c" is changed.
  - "changed::c" is emitted when the value of the key "c" is changed. It isn't emitted when the value of "a" or "b" is changed.
In this version of tfe, there is only one key ("font").
So, even if the signal doesn't have a detail, the result is the same.
But in the future version, it will probably need details.
- 158-168: Creates actions.
- 170: Sets CSS font.
- 173-181: Class initialization function.
- 177: Sets the dispose handler.
- 178: Sets the composite widget template
- 179-180: Binds private variable with child objects in the template.
- 183-186: `tfe_window_new`.
This function creates TfeWindow instance.

## TfeApplication

The file `tfeapplication.c` is now very simple.

@@@include
tfe7/tfeapplication.c
@@@

- 4-11: Activate signal handler.
It uses `tfe_window_notebook_page_new` instead of `notebook_page_new`.
- 13-20: Open signal handler.
Thanks to `tfe_window_notebook_page_new_with_files`, this handler becomes very simple.
- 22-44: Startup signal handler.
Most of the tasks are moved to TfeWindow, the remaining tasks are creating a window and setting accelerations.
- 48-64: A function `main`.

## Other files

Resource XML file.

@@@include
tfe7/tfe.gresource.xml
@@@

GSchema XML file

@@@include
tfe7/com.github.ToshioCP.tfe.gschema.xml
@@@

Meson.build

@@@include
tfe7/meson.build
@@@

## Compilation and installation.

If you build Gtk4 from the source, use `--prefix` option.

~~~
$ meson --prefix=$HOME/local _build
$ ninja -C _build
$ ninja -C _build install
~~~

If you install Gtk4 from the distribution packages, you don't need the prefix option.
Maybe you need root privilege to install it.

~~~
$ meson _build
$ ninja -C _build
$ ninja -C _build install  # or 'sudo ninja -C _build install'
~~~

Source files are in [src/tfe7](tfe7) directory.

We made a very small text editor.
You can add features to this editor.
When you add a new feature, care about the structure of the program.
Maybe you need to divide a file into several files like this section.
It isn't good to put many things into one file.
And it is important to think about the relationship between source files and widget structures.
It is appropriate that they correspond to each other in many cases.
