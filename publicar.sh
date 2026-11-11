#!/bin/bash
# Publica los labs de Obsidian en la wiki.
#   ./publicar.sh          copia los labs, revisa que la wiki compile y la sube a GitHub
#   ./publicar.sh --local  copia los labs y abre la wiki en http://localhost:8080 (no sube nada)
set -euo pipefail
cd "$(dirname "$0")"

LABS="$HOME/Documents/myBrain/97_Cybersecurity_Labs"
INDICE="00 Write-ups.md"

[ -d "$LABS" ] || { echo "No encuentro $LABS"; exit 1; }

# 1. Copia solo los labs terminados. "En progreso" y archivos de sistema no salen.
rm -rf content
mkdir content
rsync -a --exclude 'En progreso/' --exclude '.DS_Store' "$LABS/" content/

# 2. Portada: tu presentación (portada.md) + el índice de la bóveda.
{ cat portada.md; cat "content/$INDICE"; } > content/index.md
rm "content/$INDICE"

# 3. Títulos legibles y enlaces a notas privadas convertidos en texto.
/usr/bin/python3 -I - <<'EOF'
import glob, os, re

notas = {os.path.splitext(os.path.basename(p))[0].lower() for p in glob.glob('content/**/*.md', recursive=True)}
enlace = re.compile(r'(?<!!)\[\[([^\]|#]+)(#[^\]|]*)?(?:\|([^\]]+))?\]\]')

def cambiar(m):
    destino, texto = m.group(1).strip(), m.group(3) or m.group(1)
    return m.group(0) if destino.lower() in notas else texto

quitados = 0
for p in glob.glob('content/**/*.md', recursive=True):
    t = open(p, encoding='utf8').read()
    nuevo, n = enlace.subn(cambiar, t)
    # Quartz lee "Capturas/x.png" desde la raíz de la wiki: se antepone la carpeta del lab.
    carpeta = os.path.relpath(os.path.dirname(p), 'content').replace(' ', '%20')
    if carpeta != '.':
        nuevo = re.sub(r'(!\[[^\]]*\]\()(?!https?:|/)(?:\./)?([^)]+\))', lambda m: m.group(1) + carpeta + '/' + m.group(2), nuevo)
    quitados += sum(1 for m in enlace.finditer(t) if m.group(1).strip().lower() not in notas)
    nombre = os.path.splitext(os.path.basename(p))[0]
    m = re.match(r'(?i)lab_(\d+) (.+)', nombre)
    if m and not nuevo.startswith('---'):
        nuevo = '---\ntitle: "Lab %s · %s"\n---\n' % (m.group(1), m.group(2)) + nuevo
    open(p, 'w', encoding='utf8').write(nuevo)
print('Labs publicados:', len(notas) - 1, '| enlaces a notas privadas convertidos en texto:', quitados)
EOF

# 4. Vista previa local o publicación.
if [ "${1:-}" = "--copiar" ]; then
  exit 0
elif [ "${1:-}" = "--local" ]; then
  npx quartz build --serve
else
  npx quartz build
  git add content quartz.config.yaml portada.md publicar.sh
  git commit -m "Actualiza los labs ($(date +%Y-%m-%d))" || echo "No hay cambios para subir."
  # Sube siempre con la cuenta marinogscs, aunque la cuenta activa de gh sea otra.
  GH_TOKEN="$(gh auth token --user marinogscs)" \
    git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push
  echo "Listo. GitHub actualiza la wiki en 1 o 2 minutos."
fi
