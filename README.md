# Neo Server Pack (packwiz)

Сборка для сервера `135.181.126.167:25737`, NeoForge 21.1.267 / MC 1.21.1, 213 модов.

Этот репозиторий — не только исходник пака, но и **хостинг**: GitHub Pages отдаёт
`pack.toml`, `index.toml`, `mods/*.pw.toml` и файлы, по которым обновляются инстансы игроков.

## Как обновить моды

```bash
packwiz modrinth add <slug>      # добавить мод с Modrinth
packwiz update --all             # обновить все моды до свежих версий
packwiz remove <name>            # убрать мод
packwiz refresh                  # пересчитать index.toml (обязательно после правок вручную)
git add -A && git commit -m "update mods" && git push
```

Моды, которых нет на Modrinth, лежат прямо в `mods/*.jar` — их достаточно заменить
файлом и выполнить `packwiz refresh`. Клиенты получат новый файл на следующем запуске.

## BerryUp — лаунчер для игроков

`launcher/BerryUp.exe` — самодостаточное приложение для Windows (C# / .NET Framework 4.8,
который входит в Windows 10/11 по умолчанию; ничего дополнительно ставить не нужно).
Оно само находит Prism Launcher или PineconeMC, ставит инстанс, синхронизирует пак и запускает игру.
Если лаунчер не найден — показывает окно со ссылками на скачивание.

## Что лежит внутри

- `config/**` — конфиги модов и графики (шейдеры отключены через `config/iris.properties`)
- `servers.dat` — сервер уже в списке multiplayer
- `mods/*.pw.toml` — 193 мода, качаются с CDN Modrinth (в паке только хеши)
- `mods/*.jar` — 20 модов CurseForge, отдаются прямо из этого репозитория
