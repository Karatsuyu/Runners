import shutil
from pathlib import Path

def main():
    repo_root = Path(__file__).resolve().parent.parent
    frontend_menus = repo_root / 'frontend' / 'assets' / 'menus'
    backend_menus = repo_root / 'backend' / 'media' / 'store' / 'menus'

    print(f'Frontend menus: {frontend_menus}')
    print(f'Backend target: {backend_menus}')

    if not frontend_menus.exists():
        print('No se encontró la carpeta de menús en frontend.')
        return

    backend_menus.mkdir(parents=True, exist_ok=True)

    files = list(frontend_menus.glob('*'))
    if not files:
        print('No hay archivos en frontend/assets/menus para copiar.')
        return

    for f in files:
        if f.is_file():
            dest = backend_menus / f.name
            print(f'Copiando {f} -> {dest}')
            shutil.copy2(f, dest)

    print('Copia completada. Reinicia el servidor Django si está corriendo.')

if __name__ == '__main__':
    main()
