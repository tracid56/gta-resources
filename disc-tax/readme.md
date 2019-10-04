# Description

Display social media information using commands

# Installation
Add to resource folder `[esx]` or `[disc]`

Start using `start disc-tax`

# Config
Time to run Taxing
```
Config.TaxTime = {
    h = 00,
    m = 00
}
```
Tax money on hand
```
Config.TaxMoney = true
```

Tax Brackets
```
--Increasing Order
Config.TaxBrackets = {
    default = {
        percent = 10
    },
    {
        low = 0,
        high = 200000,
        percent = 5
    },
    {
        low = 200000,
        high = 500000,
        percent = 10
    }
}
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)
