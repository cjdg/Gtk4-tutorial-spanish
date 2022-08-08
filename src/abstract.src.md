#### Contenido de este repositorio

Este tutorial ilustra como escribir programas en C con la biblioteca Gtk4
se enfoca en prinpcipiantes, asi que el contenido esta limitado a los temas básicos.
La tabla de contenido se encuentra al final de esta introducción.

- Sección 3 a la 21 describe las bases, con el ejemplo de un editor simple `tfe` (Text File Editor).
- Sección 22 a la 25 describe como usar GtkDrawingArea.
- Sección 26 a la 29 describe el modelo de lista y la vista lista (GtkListView, GtkGridView y GtkColumnView).
también describe GtkExpression.

La última versión original de este tutorial (en inglés) se encuentra en [Gtk4-tutorial github repository](https://github.com/ToshioCP/Gtk4-tutorial).
Puedes leerlo desde ahí directamente sin tener que descargar nada.

#### Documentación Gtk4

Lee [Gtk API Reference](https://docs.gtk.org/gtk4/index.html)
y and [Gnome Developer Documentation Website](https://developer.gnome.org/) para mayor información.

Estos sitios son recientes (Agosto 2021)
La vieja documentación se encuentra en [Gtk Reference Manual](https://developer-old.gnome.org/gtk4/stable/) y [Gnome Developer Center](https://developer-old.gnome.org/).
El nuevo sitio se encuentra en progreso actualmente, asi que a veces tendrás que revisar la vieja version

Si deseas conocer mas acerca de GObject y el sistema de tipos, por favor lee [GObject tutorial](https://github.com/ToshioCP/Gobject-tutorial).
Los detalles de GObject son fáciles de entender y necesarios para escribir programas en Gtk4.



#### Contribución

Este tutorial se encuentra bajo desarrollo y es inestable.
Incluso aunque los ejemplos han sido probados en Gtk4 versión 4.0, pueden existir algunos errores.
Si encuentras algún bug, o errores en el tutorial y los ejemplos de C, por favor haznoslo notar.
Lo puedes publicar en (sitio original en inglés)  [github issues](https://github.com/ToshioCP/Gtk4-tutorial/issues).
También puedes publicar los archivos corregidos como un commit a [pull request](https://github.com/ToshioCP/Gtk4-tutorial/pulls).
Cuando hagas correcciones, corrige el archivo fuente, que se encuentra en la carpeta 'src',
y ejecuta `rake`para crear el archivo de salida. Los archivos GFM dentro de la carpeta 'gfm' se actualizan de manera automática.

Si tienes alguna duda, puedes publicarlo como un issue dentro del sitio.
Todas las preguntas son útiles y harán este tutorial mejor.


#### Como obtener una versión HTML o PDF

Si deseas obtener una versión HTML o PDF, la puedes hacer com `rake`, que es una versión en ruby de make.
Escribe `rake html` para HTML.
Escribe `rake pdf` para PDF.
@@@if gfm
Existe una documentación \("[Cómo construir el Tutorial Gtk4](gfm/Readme_for_developers.md)"\) que describe como hacerlo.
@@@elif html
Existe una documentación \("[Cómo construir el Tutorial Gtk4](gfm/Readme_for_developers.md)"\) que describe como hacerlo.
@@@elif latex
El apéndice "Cómo construir el Tutorial Gtk4" describe como hacerlo.
@@@end
