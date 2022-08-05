# Tutorial de Gtk4 para principiantes

<!-- 
Generar la página web 
La página github del tutorial también se encuentra disponible. Click [aqui]
The github page of this tutorial is also available. Click [here](https://toshiocp.github.io/Gtk4-tutorial/).
-->

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
Existe una documentación \("[Cómo construir el Tutorial Gtk4](gfm/Readme_for_developers.md)"\) que describe como hacerlo.


## Tabla de Contenido

1. [Prerequisitos y licencia](gfm/sec1.md)
1. [Instalar Gtk4 en una distro Linux](gfm/sec2.md)
1. [GtkApplication y GtkApplicationWindow](gfm/sec3.md)
1. [Widgets (1)](gfm/sec4.md)
1. [Widgets (2)](gfm/sec5.md)
1. [String y administración de memoria](gfm/sec6.md)
1. [Widgets (3)](gfm/sec7.md)
1. [Definir un objeto hijo](gfm/sec8.md)
1. [El archivo de interfaz de usuario (UI) y GtkBuilder](gfm/sec9.md)
1. [Sistema de compilación (Build system)](gfm/sec10.md)
1. [Inicialización y destrucción de instancias](gfm/sec11.md)
1. [Señales](gfm/sec12.md)
1. [Funciones en TfeTextView](gfm/sec13.md)
1. [Funcioes en GtkNotebook](gfm/sec14.md)
1. [tfeapplication.c](gfm/sec15.md)
1. [Archivos fuente tfe5](gfm/sec16.md)
1. [Menu y acción](gfm/sec17.md)
1. [Stateful action](gfm/sec18.md)
1. [Archivo UI para menús y acciones](gfm/sec19.md)
1. [GtkMenuButton, aceleradores, fuentes, pango y gsettings](gfm/sec20.md)
1. [Plantilla XML y widgets compuestos](gfm/sec21.md)
1. [GtkDrawingArea y Cairo](gfm/sec22.md)
1. [Eventos periódicos](gfm/sec23.md)
1. [Combinar GtkDrawingArea y TfeTextView](gfm/sec24.md)
1. [Intérprete Tiny turtle graphics](gfm/sec25.md)
1. [GtkListView](gfm/sec26.md)
1. [GtkGridView y señal 'activate' ](gfm/sec27.md)
1. [GtkExpression](gfm/sec28.md)
1. [GtkColumnView](gfm/sec29.md)
