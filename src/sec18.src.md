# Stateful action

Some actions have states.
The typical values of states is boolean or string.
However, other types of states are possible if you want.

There's an example `menu2_int16.c` in the `src/men` directory.
It behaves the same as `menu2.c`.
But it uses gint16 type of states instead of string type.

Actions which have states are called stateful.

## Stateful action without a parameter

Some menus are called toggle menu.
For example, fullscreen menu has a state which has two values -- fullscreen and non-fullscreen.
The value of the state is changed every time the menu is clicked.
An action corresponds to the fullscreen menu also have a state.
Its value is TRUE or FALSE and it is called boolean value.
TRUE corresponds to fullscreen and FALSE to non-fullscreen.

The following is an example code to implement a fullscreen menu except the signal handler.
The signal handler will be described after the explanation of this code.

~~~C
static void
app_activate (GApplication *app, gpointer user_data) {
  ... ... ...
  GSimpleAction *act_fullscreen = g_simple_action_new_stateful ("fullscreen",
                                  NULL, g_variant_new_boolean (FALSE));
  GMenuItem *menu_item_fullscreen = g_menu_item_new ("Full Screen", "win.fullscreen");
  g_signal_connect (act_fullscreen, "change-state", G_CALLBACK (fullscreen_changed), win);
  ... ... ...
}
~~~

- `act_fullscreen` is a GSimpleAction instance.
It is created with `g_simple_action_new_stateful`.
The function has three arguments.
The first argument "fullscreen" is the name of the action.
The second argument is a parameter type.
`NULL` means the action doesn't have a parameter.
The third argument is the initial state of the action.
It is a GVariant value.
GVariant will be explained in the next subsection.
The function `g_variant_new_boolean (FALSE)` returns a GVariant value which is the boolean value `FALSE`.
- `menu_item_fullscreen` is a GMenuItem instance.
There are two arguments.
The first argument "Full Screen" is a label of `menu_item_fullscreen`.
The second argument is an action.
The action "win.fullscreen" has a prefix "win" and an action name "fullscreen".
The prefix says that the action belongs to the window.
- connects the action `act_fullscreen` and the "change-state" signal handler `fullscreen_changed`.
If the fullscreen menu is clicked, then the corresponding action `act_fullscreen` is activated.
But no handler is connected to the "activate" signal.
Then, the default behavior for boolean-stated actions with a NULL parameter type like `act_fullscreen` is to toggle them via the “change-state” signal.

The following is the "change-state" signal handler.

~~~C
static void
fullscreen_changed(GSimpleAction *action, GVariant *value, gpointer win) {
  if (g_variant_get_boolean (value))
    gtk_window_maximize (GTK_WINDOW (win));
  else
    gtk_window_unmaximize (GTK_WINDOW (win));
  g_simple_action_set_state (action, value);
}
~~~

- There are three parameters.
The first parameter is the action which emits the "change-state" signal.
The second parameter is the value of the new state of the action.
The third parameter is a user data which is set in `g_signal_connect`.
- If the value is boolean type and `TRUE`, then it maximizes the window.
Otherwise unmaximizes.
- Sets the state of the action with `value`.
Note: the second argument was the toggled state value, but at this stage the state of the action has the original value.
So, you need to set the state with the new value by `g_simple_action_set_state`.

You can use "activate" signal instead of "change-state" signal, or both signals.
But the way above is the simplest and the best.

### GVariant

GVarient can contain boolean, string or other type values.
For example, the following program assigns TRUE to `value` whose type is GVariant.

~~~C
GVariant *value = g_variant_new_boolean (TRUE);
~~~

Another example is:

~~~C
GVariant *value2 = g_variant_new_string ("Hello");
~~~

`value2` is a GVariant and it has a string type value "Hello".
GVariant can contain other types like int16, int32, int64, double and so on.

If you want to get the original value, use g\_variant\_get series functions.
For example, you can get the boolean value by g\_variant_get_boolean.

~~~C
gboolean bool = g_variant_get_boolean (value);
~~~

Because `value` has been created as a boolean type GVariant and `TRUE` value, `bool` equals `TRUE`.
In the same way, you can get a string from `value2`

~~~C
const char *str = g_variant_get_string (value2, NULL);
~~~

The second parameter is a pointer to gsize type variable (gsize is defined as unsigned long).
If it isn't NULL, then the length of the string will be set by the function.
If it is NULL, nothing happens.
The returned string `str` can't be changed.

## Stateful action with a parameter

Another example of stateful actions is an action corresponds to color select menus.
For example, there are three menus and each menu has red, green or blue color respectively.
They determine the background color of a certain widget.
One action is connected to the three menus.
The action has a state which values are "red", "green" and "blue".
The values are string.
Those colors are given to the signal handler as a parameter.

~~~C
static void
app_activate (GApplication *app, gpointer user_data) {
  ... ... ...
  GSimpleAction *act_color = g_simple_action_new_stateful ("color",
                     g_variant_type_new("s"), g_variant_new_string ("red"));
  GMenuItem *menu_item_red = g_menu_item_new ("Red", "win.color::red");
  GMenuItem *menu_item_green = g_menu_item_new ("Green", "win.color::green");
  GMenuItem *menu_item_blue = g_menu_item_new ("Blue", "win.color::blue");
  g_signal_connect (act_color, "activate", G_CALLBACK (color_activated), win);
  ... ... ...
}
~~~

- `act_color` is a GSimpleAction instance.
It is created with `g_simple_action_new_stateful`.
The function has three arguments.
The first argument "color" is the name of the action.
The second argument is a parameter type which is GVariantType.
`g_variant_type_new("s")` creates GVariantType which is a string type (`G_VARIANT_TYPE_STRING`).
The third argument is the initial state of the action.
It is a GVariant.
GVariantType will be explained in the next subsection.
The function `g_variant_new_string ("red")` returns a GVariant value which has the string value "red".
- `menu_item_red` is a GMenuItem instance.
There are two arguments.
The first argument "Red" is the label of `menu_item_red`.
The second argument is a detailed action.
Its prefix is "win", action name is "color" and target is "red".
Target is sent to the action as a parameter.
The same goes for `menu_item_green` and `menu_item_blue`.
- connects the action `act_color` and the "activate" signal handler `color_activated`.
If one of the three menus is clicked, then the action `act_color` is activated with the target (parameter) which is given by the menu.
No handler is connected to "change-state" signal.
Then the default behavior is to call `g_simple_action_set_state()` to set the state to the requested value.

The following is the "activate" signal handler.

~~~C
static void
color_activated(GSimpleAction *action, GVariant *parameter, gpointer win) {
  char *color = g_strdup_printf ("label#lb {background-color: %s;}",
                                   g_variant_get_string (parameter, NULL));
  gtk_css_provider_load_from_data (provider, color, -1);
  g_free (color);
  g_action_change_state (G_ACTION (action), parameter);
}
~~~

- There are three parameters.
The first parameter is the action which emits the "activate" signal.
The second parameter is the parameter given to the action.
It is a color specified by the menu.
The third parameter is a user data which is set in `g_signal_connect`.
- `color` is a CSS string created by `g_strdup_printf`.
The parameter of `g_strdup_printf` is the same as printf C standard function.
`g_variant_get_string` gets the string contained in `parameter`.
You mustn't change or free the string.
- Sets the color of the css provider.
- Frees the string `color`.
- Changes the state by `g_action_change_state`.
The function just sets the state of the action to the parameter by `g_simple_action_set_state`.
Therefore, you can use `g_simple_action_set_state` instead of `g_action_change_state`.

Note: If you have set a "change-state" signal handler, `g_action_change_state` will emit "change-state" signal instead of calling `g_simple_action_set_state`.

### GVariantType

GVariantType gives a type of GVariant.
GVariant can contain many kinds of types.
And the type often needs to be recognized at runtime.
GVariantType provides such functionality.

GVariantType is created with a string which expresses a type.

- "b" means boolean type.
- "s" means string type.

The following program is a simple example.
It finally outputs the string "s".

@@@include
menu/gvarianttype_test.c
@@@

- `g_variant_type_new` creates GVariantType.
It uses a type string "s" which means string.
- `g_variant_type_peek_string` takes a peek at `vtype`.
It is the string "s" given to `vtype` when it was created.
- prints the string to the terminal.

## Example code
The following code includes stateful actions above.
This program has menus like this:

![menu2](../image/menu2.png){width=6.03cm height=5.115cm}

- Fullscreen menu toggles the size of the window between maximum and non-maximum.
If the window is maximum size, which is called full screen, then a check mark is put before "fullscreen" label.
- Red, green and blue menu determines the back ground color of the label, which is the child widget of the window.
The menus have radio buttons on the left of the menus.
And the radio button of the selected menu turns on.
- Quit menu quits the application.

The code is as follows.

@@@include
menu/menu2.c
@@@

- 5-26: Signal handlers.
They have already been explained.
- 30-36: `win` and `lb` are GtkApplicationWindow and GtkLabel respectively.
`win` has a title "menu2" and its default size is 400x300.
`lb` is named as "lb".
The name is used in CSS.
`lb` is set to `win` as a child.
- 38-43: Three actions are defined.
They are:
  - stateful and has no parameter.
It has a toggle state.
  - stateful and has a parameter.
Parameter is a string type.
  - stateless and has no parameter.
- 45-54: Creates GMenu and GMenuItem.
There are three sections.
- 56-61: Signals are connected to handlers.
And actions are added to GActionMap.
Because `act_fullscreen` and `act_color` have "win" prefix and belong to GtkApplicationWindow,
they are added to `win`.
GtkApplicationWindow implements GActionModel interface like GtkApplication.
`act_quit` has "app" prefix and belongs to GtkApplication.
It is added to `app`.
- 63-77: Connects and builds the menus.
Useless GMenuItem are freed.
- 79-80: GMenuModel `menubar` is inserted to `app`.
Sets show menubar property of `win` to `TRUE`.
Note: `gtk_application_window_set_show_menubar` creates GtkPopoverMenubar from GMenuModel.
This is a different point between Gtk3 and Gtk4.
And you can use GtkPopoverMenubar directly and set it as a descendant widget of the window.
You may use GtkBox as a child widget of the window and insert GtkPopoverMenubar as the first child of the box.
- 82-87: Sets CSS.
`provider` is GtkCssProvider which is defined in line three as a static variable.
Its CSS data is:
`label#lb {background-color: red;}`.
"label#lb" is called selector.
"label" is the node of GtkLabel.
"#" precedes an ID which is an identifiable name of the widget.
"lb" is the name of GtkLabel `lb`.
(See line 35).
The style is surrounded by open and close braces.
The style is applied to GtkLabel which has a name "lb".
Other GtkLabel have no effect from this.
The provider is added to GdkDisplay.
- 90: Shows the window.

