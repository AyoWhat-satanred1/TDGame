export type DefaultData = {
    money: number,
    exp: number,
    level: number,
    wins: number,
    selectedTowers: { string },
    ownedTowers: {
        [string]: {
            Name: string
        }
    },
}

return {
    defaultData = {
        money = 100,
        exp = 0,
        level = 1,
        wins = 0,
        selectedTowers = {},
        ownedTowers = {}
    } :: DefaultData
}