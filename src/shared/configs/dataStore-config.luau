export type DefaultData = {
    money: number,
    exp: number,
    level: number,
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
        selectedTowers = {},
        ownedTowers = {}
    } :: DefaultData
}