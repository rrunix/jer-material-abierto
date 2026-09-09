# Material docente en abierto de la asignatura Juegos en Red del Grado en Diseño y Desarrollo de Videojuegos

Material docente en abierto de la asignatura "Juegos en Red" del Grado en Diseño y Desarrollo de Videojuegos de la Universidad Rey Juan Carlos (URJC). Impartida en dos sedes, campus de Quintana y Móstoles. Depositado en el BURJC Digital [https://hdl.handle.net/10115/112657](https://hdl.handle.net/10115/112657).

**Autores**: 

- Rubén Rodríguez (ruben.rodriguez@urjc.es) - URJC
- Natalia Madrueño (natalia.madrueno@urjc.es) - URJC

**Fecha**: 10/11/2025.

**Licencia**: Este trabajo está licenciado bajo [Creative Commons Reconocimiento-CompartirIgual 4.0 Internacional](https://creativecommons.org/licenses/by-sa/4.0/).

## Sobre Este Repositorio

Este repositorio contiene todo el material en abierto de la asignatura "Juegos en Red", desarrollado con Quarto como un libro interactivo. El material incluye:

- **Guía de estudio**: Planificación y objetivos del curso
- **Apuntes de la asignatura**: Apuntes completos de todos los temas
- **Diapositivas**: Presentaciones utilizadas en clase (incluídas en formato PDF)
- **Ejercicios**: Problemas y prácticas para consolidar conocimientos
- **Ejemplos de código**: Referencias a los repositorios.

El contenido cubre los conceptos fundamentales y la implementación práctica de juegos multijugador en red, integrando teoría y práctica en cinco áreas principales: redes de ordenadores, desarrollo en el cliente, desarrollo de juegos con tecnologías web, desarrollo en el servidor y comunicación cliente-servidor en tiempo real.

## Estructura del Contenido

El libro está organizado en tres partes principales:

### Parte 1: Introducción a Redes
Ubicada en `ch/part_networks/`, esta sección cubre los fundamentos de redes de ordenadores:
- **Capítulo 1**: Introducción a las Redes de Ordenadores (`network_intro/`)
- **Capítulo 2**: Capa de Acceso a la Red (`access_layer/`)
- **Capítulo 3**: Capa de Red (`network_layer/`)
- **Capítulo 4**: Capa de Transporte (`transport_layer/`)
- **Capítulo 5**: Capa de Aplicación (`application_layer/`)

### Parte 2: Desarrollo en el Cliente
Ubicada en `ch/part_client/`, esta sección cubre tecnologías de desarrollo web:
- **JavaScript**: Fundamentos y programación orientada a objetos (`js/`)
- **HTML y CSS**: Estructura y estilo de páginas web (`htmlcss/`)
- **Phaser**: Motor de juegos 2D para navegador (`phaser/`)

### Parte 3: Desarrollo en el Servidor y Comunicación
Ubicada en `ch/part_servercoms/`, esta sección cubre la comunicación cliente-servidor:
- **APIs REST**: Introducción, consumo en el cliente e implementación en el servidor (`rest/`)
- **WebSockets**: Comunicación bidireccional en tiempo real, cliente y servidor (`ws/`)

### Recursos Adicionales

- **Diapositivas**: Material de presentación en el directorio `slides/` (formato PDF)
- **Ejercicios**: Problemas y prácticas en `ch/exercises/`
- **Ejemplos de Código**: Implementaciones de ejemplo en `ch/code/`
- **Guía de Estudio**: Resumen completo del curso en `ch/study/study_guide.qmd`

## Estructura del Proyecto

```
jerbook/
├── ch/                         # Capítulos principales del contenido
│   ├── part_networks/          # Fundamentos de redes
│   ├── part_client/            # Desarrollo en el cliente
│   ├── part_servercoms/        # Servidor y comunicación
│   ├── exercises/              # Ejercicios prácticos
│   ├── code/                   # Ejemplos de código
│   ├── study/                  # Guia de estudio
│   └── slides/                 # Referencias a diapositivas
├── slides/                     # Diapositivas en PDF
├── images/                     # Recursos de imágenes
├── _quarto.yml                 # Configuración de Quarto
├── index.qmd                   # Página principal del libro
├── cover/                      # Portada del libro
├── references.bib              # Bibliografía
└── references.qmd              # Sección de referencias
```

## Requisitos Previos

Antes de compilar el libro, asegúrate de tener instalado lo siguiente:

1. **Quarto**: Descárgalo desde [https://quarto.org/docs/get-started/](https://quarto.org/docs/get-started/)
2. **Mermaid CLI**: Para renderizar diagramas
   ```bash
   npm install -g @mermaid-js/mermaid-cli
   ```
3. **WeasyPrint** (para generación de PDF): Instálalo mediante pip
   ```bash
   pip install weasyprint
   ```

## Compilar el Libro

### Paso 1: Preparar las Diapositivas

Es necesario tener instalado `pdftoppm` (incluido en `poppler`) y `cwebp`
(incluido en `webp`):

```bash
brew install poppler webp
```

Las diapositivas viven en su propio repositorio,
[jer_slides](https://github.com/rrunix/jer_slides), incluido aquí como submódulo
en `slides/jer_slides`. Si has clonado este repositorio sin `--recurse-submodules`,
inicialízalo:

```bash
git submodule update --init slides/jer_slides
```

Después genera las imágenes que el libro incrusta, a partir de los PDFs del
submódulo (`slides/jer_slides/PDF/`):

```bash
cd slides && ./convert_pdfs_to_images.sh      # -f para rehacer todos los decks
```

El script escribe las imágenes en `slides/img/<deck>/slide-N.webp` (fuera del
submódulo, y sin seguimiento de git) y solo regenera los decks cuyo PDF haya
cambiado.

Los decks se rasterizan a 96 DPI, que es el tamaño nativo con el que están
diseñados (1280x720), y se guardan en WebP sin pérdida: los mismos píxeles que
en PNG ocupando un 60% menos. No uses WebP con pérdida: en imágenes de colores
planos y texto nítido como éstas resulta *más* grande, y además hincha el PDF
del libro, porque WeasyPrint recomprime cada imagen y los artefactos empeoran
esa recompresión.

Un deck por tema:

| PDF en `jer_slides/PDF/` | Tema |
| --- | --- |
| `sub_introduction.pdf` | Introducción a la asignatura |
| `ch1_p1_net_introduction.pdf` | Introducción a las redes de ordenadores |
| `ch1_p2_access_layer.pdf` | Capa de acceso a la red |
| `ch1_p3_network.pdf` | Capa de red |
| `ch1_p4_transport.pdf` | Capa de transporte |
| `ch1_p5_application.pdf` | Capa de aplicación |
| `ch2_p1_js.pdf` | JavaScript |
| `ch2_p2_js_classes.pdf` | Programación orientada a objetos en JS |
| `ch3_p1_phaser.pdf` | Introducción a Phaser |
| `ch4_rest.pdf` | APIs REST |
| `ch5_websockets.pdf` | WebSockets |

Si editas las diapositivas, regenera los PDFs dentro del submódulo con
`(cd slides/jer_slides && ./render-pdf.sh)`, y recuerda que hacen falta dos
commits: uno en `jer_slides` con el cambio y otro aquí para actualizar el
puntero del submódulo.

### Paso 2: Pre-renderizar los Diagramas

Es necesario tener instalado mermaid-cli. Para instalarlo con node:

```bash
npm install -g @mermaid-js/mermaid-cli
```

Ejecuta el script de pre-procesamiento de diagramas Mermaid:
```bash
./convert_mermaid.sh
```

Este script convierte los diagramas Mermaid a imágenes para mejorar la compatibilidad entre formatos de salida.

### Paso 3: Compilar el Libro

#### Generar Versión HTML
```bash
quarto render
```

La salida HTML se generará en el directorio `_book/`.

#### Generar Versión PDF
```bash
quarto render --to pdf
```

El PDF incluirá la portada personalizada definida en `cover/_cover.html`.

#### Generar un Formato Específico
```bash
quarto render --to html
# o
quarto render --to pdf
```

### Paso 4: Previsualizar el Libro

Para previsualizar el libro con recarga automática durante el desarrollo:
```bash
quarto preview
```

Esto iniciará un servidor local (típicamente en `http://localhost:4200`) y se actualizará automáticamente cuando hagas cambios.

## Configuración

La configuración del libro está definida en `_quarto.yml`:
- **Idioma**: Español (`lang: es`)
- **Formatos de Salida**: HTML y PDF
- **Tema HTML**: Cerulean con CSS personalizado (`styles.css`)
- **Motor PDF**: WeasyPrint
- **Numeración**: Secciones numeradas hasta profundidad 2
- **Bibliografía**: Formato BibTeX en `references.bib`

## Contribuir

Al añadir nuevo contenido:
1. Coloca los archivos de capítulos en el directorio de parte apropiado bajo `ch/`
2. Actualiza `_quarto.yml` para incluir los nuevos capítulos en la estructura del libro
3. Añade cualquier imagen al directorio `images/`
4. Actualiza las entradas de bibliografía en `references.bib` según sea necesario
5. Sigue el formato Quarto markdown existente y las convenciones de estilo

## Soporte

Para preguntas o problemas relacionados con el contenido del curso, contacta con los autores en sus respectivas direcciones de correo electrónico mencionadas arriba.
