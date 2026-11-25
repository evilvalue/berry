# Neo Server Pack (packwiz)

Сборка для сервера `135.181.126.167:25737`, NeoForge 21.1.267 / MC 1.21.1, 184 мода.

Create и все его аддоны (включая физику Sable/Aeronautics) из сборки убраны.

## Вход через Telegram

`mods/berryauth-1.0.0.jar` (BerryTrip Auth) едет и клиентам, и серверу. Бот
@killberriesbot привязывает ник к Telegram, в игре `/verify КОД` подтверждает ник
и выдаёт токен; дальше вход без кода. На сервере настройка — в
`config/berryauth-server.toml`, ключ подписи создаётся сам.

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

## BerryUp 3 — лаунчер для игроков

**Скачать:** <https://evilvalue.github.io/berry/launcher/BerryUp.jar>
(релизы: <https://github.com/evilvalue/berry-launcher/releases>).

BerryUp переписан на Java: установщика, exe и архивов больше нет — это один jar.
Лаунчер работает поверх **Prism Launcher** или **PineconeMC** — их нужно поставить
один раз, Java отдельно не требуется (BerryUp запускается на Java из Prism).
Запусти jar из любой папки: при первом запуске BerryUp сам поставится в
`%LOCALAPPDATA%\BerryUp`, сделает ярлыки на рабочем столе и в «Пуске» и уберёт
скачанный файл. Дальше — запуск с ярлыка: он берёт Java из Prism, поэтому на
масштабе Windows 125–150% шрифт не мылится. Лаунчер найдёт инстанс BerryTrip,
поставит или обновит сборку и запустит игру, а обновления BerryUp применяет сам.
Скин можно посмотреть в 3D прямо в лаунчере. Инструкция для игроков — на главной
странице сайта.

Старые `launcher/BerryUp.exe` и `latest.json` остаются для версии 2.1.2:
exe-версия не умеет обновляться в jar, её стоит заменить вручную.

### Как выпустить новую версию BerryUp

1. Поднять `VERSION` в `launcher-java/src/main/java/ru/berrytrip/berryup/Cfg.java`.
2. `powershell -ExecutionPolicy Bypass -File build\publish-java.ps1 -Notes "что нового"` —
   соберёт fat jar, посчитает SHA-256 и обновит `launcher/BerryUp.jar` вместе с
   `launcher/latest-java.json`.
3. `git add -A; git commit; git push` — Pages отдаст новую версию, и запущенные
   лаунчеры предложат обновиться.
4. По желанию: релиз в <https://github.com/evilvalue/berry-launcher>.

Исходники лаунчера живут в отдельном репозитории:
<https://github.com/evilvalue/berry-launcher>.
