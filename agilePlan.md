# Potenciální agilní plán vývoje

Tento dokument popisuje potenciální agilní plán, který bych použil, kdybych pracoval v týmu. V realitě byl projekt realizován samostatně, ale níže je popsán plán, který bych dodržel při práci s kolegy.

## Fáze vývoje

### Sprint 0: Příprava (1 den)
#### Cíle:
- Nastavení vývojového prostředí.
- Příprava nástrojů pro správu verzí a sledování chyb.
- Vyhledání a příprava potřebných assetů: obrázky, sprites, zvukové efekty, hudba, fonty.
- Strukturalizace projektu (složky, soubory, názvy...)

#### Výstupy:
- Konfigurace vývojového prostředí.
- Inicializace verzovacího systému.
- Seznam zdrojů assetů připraven k implementaci.

### Sprint 1: Základní Hratelnost (2-3 dny)
#### Cíle:
- Implementace hráčovy postavy s pohybem doleva, doprava a skokem pomocí sprite sheetu pro animaci.
- Vývoj systému padajících log a jejich klasifikace (dobré vs. špatné).
- Implementace skórovacího systému včetně funkce "streak" (počet chycených log za sebou), kde hráč získává body za každé sebrané dobré logo. Bodový zisk roste s každým dalším sebraným logem ve streaku (např. pokud je streak 20, za další sebrané logo hráč získá 21 bodů).
- Resetování streaku, pokud dobré logo propadne dolů obrazovkou.

#### Výstupy:
- Funkční animace postavy s využitím sprite sheetu.
- Mechanika padání log a skórování implementována, včetně logiky streaku.

### Sprint 2: Power-upy a UI (2-3 dny)
#### Cíle:
- Přidání power-upů: bomba, magnet, štít.
- Implementace boxů, které se objevují na herní ploše po dosažení streaku 10 (10 UTB log chycených za sebou).
- Vytvoření mechanismu pro získání power-upů prostřednictvím rozbíjení boxů.
- Vývoj uživatelského rozhraní (startovní a ukončovací obrazovka, menu).

#### Výstupy:
- Po dosažení streaku 10 se na obrazovce objeví box. Tento box lze rozbít klávesou určenou pro útok, což hráči přidá do inventáře jeden z power-upů.
- Bomby zničí všechny loga na obrazovce, magnety přitáhnou všechna dobrá UTB loga k hráči a odstrčí špatná loga, zatímco štít poskytne hráči dodatečný život reprezentovaný bublinou se srdcem.
- UI je intuitivní a plně funkční.

### Sprint 3: Finální Úpravy a Testing (1 týden)
#### Cíle:
- Testování hry na různých zařízeních.
- Ladění chyb a optimalizace výkonu.
- Příprava dokumentace a uživatelské příručky.
- Příprava hry na vydání.

#### Výstupy:
- Hra je odladěná a optimalizovaná.
- Dokumentace a uživatelská příručka jsou kompletní a připraveny.
