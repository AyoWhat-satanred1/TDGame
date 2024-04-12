-- unused (currently not maintained)
local Packages = game:GetService("ReplicatedStorage").Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

type LevelBarProps = {
    level: number,
    targetLevel: number
}

local LevelBar: React.FC<LevelBarProps> = function(props)
    return e("Frame", {
        Position = UDim2.fromScale(0.075, 0.55),
        Size = UDim2.fromScale(0.85, 0.35),
        BackgroundColor3 = Color3.new(0.321569, 0.098039, 0.941176),
        BackgroundTransparency = 0.2
    }, {
        LevelText = e("TextLabel", {
            Position = UDim2.fromScale(0.35, 0.1),
            Size = UDim2.fromScale(0.3, 0.8),
            BackgroundTransparency = 1,
            TextScaled = true,
            Text = `{props.level}/{props.targetLevel}`,
            ZIndex = 2
        }, {
            UIStroke = e("UIStroke"),
        }),

        Bar = e("Frame", {
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(props.level / props.targetLevel, 1),
            BackgroundColor3 = Color3.new(0.811765, 0.450980, 0.952941),
            BackgroundTransparency = 0.6
        })
    })
end

local LevelComponent: React.FC<{}> = function()
    return e("Frame", {
        Position = UDim2.fromScale(0.05, 0.82),
        Size = UDim2.fromScale(0.9, 0.16),
        BackgroundColor3 = Color3.new(0.058824, 0.925490, 0.811765)
    }, {
        UICorner = e("UICorner", {
            CornerRadius = UDim.new(0.2, 0.2)
        }),

        UIStroke = e("UIStroke", {
            Color = Color3.new(0.223529, 0.145098, 0.941176),
            Thickness = 4
        }),

        UIGradient = e("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0.156863, 0.768627, 0.952941)),
                ColorSequenceKeypoint.new(1, Color3.new(0.015686, 0.305882, 0.933333))
            }),
            Rotation = 90
        }),

        LevelText = e("TextLabel", {
            Position = UDim2.fromScale(0.3, 0.12),
            Size = UDim2.fromScale(0.4, 0.35),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextStrokeColor3 = Color3.fromRGB(0, 0, 255),
            TextStrokeTransparency = 0.5,
            Text = "Level : SomeLevel",
            TextScaled = true
        }),

        LevelBar = LevelBar({
            level = 1,
            targetLevel = 2
        })
    })
end

return function(target)
    local root = ReactRoblox.createRoot(target)
    root:render(e(LevelComponent))

    return function()
        root:unmount()
    end
end
