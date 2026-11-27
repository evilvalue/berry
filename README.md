# Neo Server Pack (packwiz)

Сборка для сервера `135.181.126.167:25737`, NeoForge 21.1.267 / MC 1.21.1, 184 мода.

Create и все его аддоны (включая физику Sable/Aeronautics) из сборки убраны.

## Вход через Telegram

`mods/berryauth-1.2.0.jar` (BerryTrip Auth) едет и клиентам, и серверу. Лаунчер
просит у мода одноразовую ссылку, бот @killberriesbot по `/start` сразу привязывает
ник к Telegram и добавляет его в вайтлист, а лаунчер забирает готовый токен.
На сервере настройка — в `config/berryauth-server.toml`, ключ подписи создаётся сам;
API лаунчера слушает порт `authApiPort` (25712).

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

## BerryTrip Launcher

Новый лаунчер для игроков — самостоятельный форк Prism Launcher:
<https://github.com/evilvalue/prism-berry>. Отдельный Prism, Java и ручная
сборка не нужны: лаунчер сам скачивает Java, пак и обновления.

Скачать: <https://github.com/evilvalue/prism-berry/releases/latest>

Сайт отдаёт установщик и портативный zip из последнего GitHub-релиза через
JavaScript; статические ссылки ведут на страницу релизов, поэтому страница
не ломается при смене версии. SHA-256 берётся из поля `digest` GitHub API.

Старые файлы `launcher/BerryUp.*` и `launcher/latest*.json` остаются только
для совместимости с BerryUp 3. Новый сайт на них не ссылается.

### Как обновить сайт

1. Измени `index.html` или файлы в `img/`/`fonts/`.
2. `git add -A && git commit -m "site: ..." && git push` — GitHub Pages
   пересоберёт страницу автоматически.
3. Проверь <https://evilvalue.github.io/berry/> и ссылки на релиз.

Исходники лаунчера: <https://github.com/evilvalue/prism-berry>.
