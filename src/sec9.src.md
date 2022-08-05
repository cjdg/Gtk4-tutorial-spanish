# The User Interface (UI) file and GtkBuilder

## New, Open and Save button

In the last section we made the almost simplest editor possible.
It reads files in the `app_open` function at start-up and writes them out when closing the window.
It works but is not very good.
It would be better if we had "New", "Open", "Save" and "Close" buttons.
This section describes how to put those buttons into the window.
Signals and handlers will be explained later.

![Screenshot of the file editor](../image/screenshot_tfe2.png){width=9.3cm height=6.825cm}

The screenshot above shows the layout.
The function `app_open` in the source code `tfe2.c` is as follows.

@@@include
tfe/tfe2.c app_open
@@@

The aim is to build the widgets of the main application window.

- 25-27: Creates a GtkApplicationWindow instance and sets the title and default size.
- 29-30: Creates a GtkBox instance `boxv`.
It is a vertical box and a child of GtkApplicationWindow.
It has two children.
The first child is a horizontal box.
The second child is a GtkNotebook.
- 32-33: Creates a GtkBox instance `boxh` and appends it to `boxv` as a first child.
- 35-40: Creates three dummy labels.
The labels `dmy1` and `dmy3` has a character width of ten.
The other label `dmy2` has hexpand property which is set to be TRUE.
This makes the label expands horizontally as long as possible.
- 41-44: Creates four buttons.
- 46-52: Appends these GtkLabel and GtkButton to `boxh`.
- 54-57: Creates a GtkNotebook instance and sets hexpand and vexpand properties TRUE.
This makes it expand horizontally and vertically as big as possible.
It is appended to `boxv` as the second child.

The number of lines to build the widgets is 33(=57-25+1).
We also needed many additional variables (`boxv`, `boxh`, `dmy1`, ...),
most of which weren't  necessary, except for building the widgets.
Are there any good solution to reduce these work?

Gtk provides GtkBuilder.
It reads user interface (UI) data and builds a window.
It reduces this cumbersome work.

## The UI File

First, let's look at the UI file `tfe3.ui` that is used to define the widget structure.

@@@include
tfe/tfe3.ui
@@@

The structure of this file is XML.
Constructs that begin with `<` and end with `>` are called tags.
There are two types of tags, the start tag and the end tag.
For example, `<interface>` is a start tag and `</interface>` is an end tag.
The UI file begins and ends with interface tags.
Some tags, for example object tags, can have a class and id attributes in their start tag.

- 1: The first line is XML declaration.
It specifies that the version of XML is 1.0 and the encoding is UTF-8.
Even if the line is left out, GtkBuilder builds objects from the ui file.
But ui files must use UTF-8 encoding, or GtkBuilder can't recognize it and a fatal error occurs.
- 3-6: An object with `GtkApplicationWindow` class and `win` id is defined.
This is the top level window.
And the three properties of the window are defined.
`title` property is "file editor", `default-width` property is 600 and `default-height` property is 400.
- 7: child tag means a child of the widget above.
For example, line 7 tells us that GtkBox object which id is "boxv" is a child widget of `win`.

Compare this ui file and the lines 25-57 in the source code of `app_open` function.
Those two describe the same structure of widgets.

You can check the ui file with `gtk4-builder-tool`.

- `gtk4-builder-tool validate <ui file name>` validates the ui file.
If the ui file includes some syntactical error, `gtk4-builder-tool` prints the error.
- `gtk4-builder-tool simplify <ui file name>` simplifies the ui file and prints the result.
If `--replace` option is given, it replaces the ui file with the simplified one.
If the ui file specifies a value of property but it is default, then it will be removed.
And some values are simplified.
For example, "TRUE"and "FALSE" becomes "1" and "0" respectively.
However, "TRUE" or "FALSE" is better for maintenance.

It is a good idea to check your ui file before compiling.

## GtkBuilder

GtkBuilder builds widgets based on the ui file.

~~~C
GtkBuilder *build;

build = gtk_builder_new_from_file ("tfe3.ui");
win = GTK_WIDGET (gtk_builder_get_object (build, "win"));
gtk_window_set_application (GTK_WINDOW (win), GTK_APPLICATION (app));
nb = GTK_WIDGET (gtk_builder_get_object (build, "nb"));
~~~

The function `gtk_builder_new_from_file` reads the file given as an argument.
Then, it builds the widgets and creates GtkBuilder object.
The function `gtk_builder_get_object (build, "win")` returns the pointer to the widget `win`, which is the id in the ui file.
All the widgets are connected based on the parent-children relationship described in the ui file.
We only need `win` and `nb` for the program after this, so we don't need to take out any other widgets.
This reduces lines in the C source file.

@@@shell
cd tfe; diff tfe2.c tfe3.c
@@@

`60,103c61,65` means 44 (=103-60+1) lines are changed to 5 (=65-61+1) lines.
Therefore, 39 lines are reduced.
Using ui file not only shortens C source files, but also makes the widgets' structure clear.

Now I'll show you `app_open` function in the C file `tfe3.c`.

@@@include
tfe/tfe3.c app_open
@@@

The whole source code of `tfe3.c` is stored in [src/tfe](tfe) directory.
If you want to see it, click the link above.

### Using ui string

GtkBuilder can build widgets using string.
Use the function `gtk_builder_new_from_string` instead of `gtk_builder_new_from_file`.

~~~C
char *uistring;

uistring =
"<interface>"
  "<object class="GtkApplicationWindow" id="win">"
    "<property name=\"title\">file editor</property>"
    "<property name=\"default-width\">600</property>"
    "<property name=\"default-height\">400</property>"
    "<child>"
      "<object class=\"GtkBox\" id=\"boxv\">"
        "<property name="orientation">GTK_ORIENTATION_VERTICAL</property>"
... ... ...
... ... ...
"</interface>";

build = gtk_builder_new_from_stringfile (uistring);
~~~

This method has an advantage and disadvantage.
The advantage is that the ui string is written in the source code.
So ui file is not necessary on runtime.
The disadvantage is that writing C string is a bit bothersome because of the double quotes.
If you want to use this method, you should write a script that transforms ui file into C-string.

- Add backslash before each double quote.
- Add double quotes at the left and right of the string in each line.

### Using Gresource

Using Gresource is similar to using string.
But Gresource is compressed binary data, not text data.
And there's a compiler that compiles ui file into Gresource.
It can compile not only text files but also binary files such as images, sounds and so on.
And after compilation, it bundles them up into one Gresource object.

An xml file is necessary for the resource compiler `glib-compile-resources`.
It describes resource files.

@@@include
tfe/tfe3.gresource.xml
@@@

- 2: `gresources` tag can include multiple gresources (gresource tags).
However, this xml has only one gresource.
- 3: The gresource has a prefix `/com/github/ToshioCP/tfe3`.
- 4: The gresource has `tfe3.ui`.
And it is pointed by `/com/github/ToshioCP/tfe3/tfe3.ui` because it needs prefix.
If you want to add more files, then insert them between line 4 and 5.

Save this xml text to `tfe3.gresource.xml`.
The gresource compiler `glib-compile-resources` shows its usage with the argument `--help`.

@@@shell
LANG=C glib-compile-resources --help
@@@

Now run the compiler.

    $ glib-compile-resources tfe3.gresource.xml --target=resources.c --generate-source

Then a C source file `resources.c` is generated.
Modify `tfe3.c` and save it as `tfe3_r.c`.

~~~C
#include "resources.c"
... ... ...
... ... ...
build = gtk_builder_new_from_resource ("/com/github/ToshioCP/tfe3/tfe3.ui");
... ... ...
... ... ...
~~~

Then, compile and run it.
The window appears and it is the same as the screenshot at the beginning of this page.
