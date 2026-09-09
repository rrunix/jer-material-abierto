#!/bin/bash

# Convierte los PDFs de las diapositivas (submódulo jer_slides) a imágenes PNG.
#
# Las imágenes se escriben en png/<deck>/slide-N.png, FUERA del submódulo, para
# no dejar ficheros sin seguimiento dentro de jer_slides. El capítulo
# ch/slides/slides.qmd las incrusta desde ahí.
#
# Uso: ./convert_pdfs_to_images.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PDF_DIR="$ROOT/jer_slides/PDF"
OUT_ROOT="$ROOT/png"

command -v pdftoppm >/dev/null 2>&1 || {
    echo "Falta 'pdftoppm' en el PATH (instálalo con: brew install poppler)." >&2
    exit 1
}

[ -d "$PDF_DIR" ] || {
    echo "No existe $PDF_DIR. ¿Falta inicializar el submódulo?" >&2
    echo "  git submodule update --init slides/jer_slides" >&2
    exit 1
}

shopt -s nullglob
pdfs=("$PDF_DIR"/*.pdf)
shopt -u nullglob

[ ${#pdfs[@]} -gt 0 ] || {
    echo "No hay PDFs en $PDF_DIR. Genéralos con: (cd slides/jer_slides && ./render-pdf.sh)" >&2
    exit 1
}

for pdf in "${pdfs[@]}"; do
    name="$(basename "$pdf" .pdf)"
    out="$OUT_ROOT/$name"

    printf '==> %-32s ' "$name"

    # Regenera solo si el PDF es más reciente que la primera imagen ya generada.
    if [ -d "$out" ] && [ -n "$(find "$out" -name 'slide-*.png' -newer "$pdf" -print -quit)" ]; then
        echo "al día ($(ls "$out"/slide-*.png | wc -l | tr -d ' ') diapositivas)"
        continue
    fi

    rm -rf "$out"
    mkdir -p "$out"
    pdftoppm -png -r 150 "$pdf" "$out/slide"
    echo "$(ls "$out"/slide-*.png | wc -l | tr -d ' ') diapositivas"
done

echo
echo "PNGs en $OUT_ROOT"
