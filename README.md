# Nultý domácí úkol

_Tento domácí úkol slouží čistě k otestování řešení a odevzdávání úkolů na Gitlabu._


## Zadání

V souboru `main.jl` je definována metoda `f`, v tento okamžik s prázdným tělem.
Doplňte kód tak, aby výraz `f(1)` měl hodnotu `2`.


## Řešení

Nejprve si vytvořte větev vycházející z `assignment/00-test`, doporučuji ji nazvat `solution/00-test`, ale není to nutné.
Toho lze lokálně docílit například takto:

```shell
$ git checkout assignment/00-test
$ git checkout -b solution/00-test
```

Poté proveďte své úpravy v souboru `main.jl` na větvi `solution/00-test`.
Když jste s nimi spokojeni, commitněte je a pushněte do repozitáře.

```shell
$ git add main.jl
$ git commit -m 'Moje řešení.'
$ git push --set-upstream origin solution/00-test 
```

Nyní na Gitlabu vytvořte _Merge request_ (MR) z větve s řešením (`solution/00-test`) do větve se zadáním (`assignment/00-test`).

Pokud na řešení stále pracujete, přidejte do názvu MR prefix `WIP:` a přiřaďte se k němu jako řešitel/ka (_Assignee_).
Na stránce MR vidíte přehledně své změny, vidíte i stav případných testů.

Pokud řešení považujete za kompletní a chcete ho odevzdat, odstraňte prefix `WIP:` z názvu a přiřaďte MR mě (Tomáš Kalvoda).
Diskuzi nad řešením budeme vést právě na stránce s MR.


## Lokální spuštění testů

Stačí v adresáři se souborem `main.jl` spustit

```shell
$ julia --color=yes test/runtests.jl
```
