#!/bin/bash

# Convierte los PDFs de las diapositivas (submódulo jer_slides) a imágenes.
#
# Los decks están diseñados a 1280x720, así que se rasterizan a 96 DPI para
# obtener exactamente ese tamaño: a 150 DPI salían a 2000x1125, un 56% más de
# píxeles que nadie llega a ver ni en el HTML ni en el PDF.
#
# El formato de salida es WebP sin pérdida: mismos píxeles que el PNG, pero
# ~60% menos de tamaño en este tipo de imagen (colores planos y texto nítido).
# Ojo: WebP con pérdida sería MÁS grande aquí, y además hincharía el PDF del
# libro, porque WeasyPrint recomprime cada imagen y los artefactos estropean
# esa recompresión.
#
# Las imágenes se escriben en img/<deck>/slide-N.webp, FUERA del submódulo, para
# no dejar ficheros sin seguimiento dentro de jer_slides. El capítulo
# ch/slides/slides.qmd las incrusta desde ahí.
#
# Uso:
#   ./convert_pdfs_to_images.sh           # solo los decks cuyo PDF haya cambiado
#   ./convert_pdfs_to_images.sh -f        # rehace todos

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PDF_DIR="$ROOT/jer_slides/PDF"
OUT_ROOT="$ROOT/img"
DPI=96
FORCE=0

[ "${1:-}" = "-f" ] && FORCE=1

for tool in pdftoppm cwebp; do
    command -v "$tool" >/dev/null 2>&1 || {
        echo "Falta '$tool' en el PATH." >&2
        [ "$tool" = pdftoppm ] && echo "  Instálalo con: brew install poppler" >&2
        [ "$tool" = cwebp ]    && echo "  Instálalo con: brew install webp" >&2
        exit 1
    }
done

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

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT INT TERM

for pdf in "${pdfs[@]}"; do
    name="$(basename "$pdf" .pdf)"
    out="$OUT_ROOT/$name"

    printf '==> %-32s ' "$name"

    if [ "$FORCE" -eq 0 ] && [ -d "$out" ] &&
       [ -n "$(find "$out" -name 'slide-*.webp' -newer "$pdf" -print -quit)" ]; then
        echo "al día ($(ls "$out"/slide-*.webp | wc -l | tr -d ' ') diapositivas)"
        continue
    fi

    rm -rf "$TMP/raster" "$out"
    mkdir -p "$TMP/raster" "$out"

    pdftoppm -png -r "$DPI" "$pdf" "$TMP/raster/slide"

    # cwebp en paralelo; -z por defecto (con -z 9 tarda ~28x más y solo gana un 4%).
    find "$TMP/raster" -name 'slide-*.png' -print0 |
        xargs -0 -P "$(sysctl -n hw.ncpu)" -I{} \
            bash -c 'cwebp -quiet -lossless "$1" -o "$2/$(basename "${1%.png}").webp"' _ {} "$out"

    echo "$(ls "$out"/slide-*.webp | wc -l | tr -d ' ') diapositivas, $(du -sh "$out" | cut -f1 | tr -d ' ')"
done

echo
echo "Imágenes en $OUT_ROOT ($(du -sh "$OUT_ROOT" | cut -f1 | tr -d ' '))"
