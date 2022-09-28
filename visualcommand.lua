--> Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

--> Variables
local Library = {}
local Utility = {}
local Commands = {}
local Config = {}
local ConfigUpdates = {}
local Dragging = false
local BreakLoops = false
local ChangeTheme = false

--> Utility Functions
do
    function Utility:Log(Type, Message)
        Type = Type:lower()

        if Type == "error" then
            error("[ Visual ] Error: " .. Message)
        elseif Type == "log" then
            print("[ Visual ] " .. Message)
        elseif Type == "warn" then
            warn("[ Visual ] Warning: " .. Message)
        end
    end

    function Utility:HasProperty(Instance, Property)
        local Success = pcall(function()
            return Instance[Property]
        end)

        return Success and not Instance:FindFirstChild(Property)
    end

    function Utility:Tween(Instance, Properties, Duration, ...)
        local TweenInfo = TweenInfo.new(Duration, ...)
        TweenService:Create(Instance, TweenInfo, Properties):Play()
    end

    function Utility:Create(InstanceName, Properties, Children)
        local Object = Instance.new(InstanceName)
        local Properties = Properties or {}
        local Children = Children or {}

        for Index, Property in next, Properties do
            Object[Index] = Property
        end

        for _, Child in next, Children do
            Child.Parent = Object
        end

        return Object
    end

    function Utility:Lighten(Color)
        local H, S, V = Color:ToHSV()

        V = math.clamp(V + 0.03, 0, 1)

        return Color3.fromHSV(H, S, V)
    end

    function Utility:Darken(Color)
        local H, S, V = Color:toHSV()

        V = math.clamp(V - 0.35, 0, 1)

        return Color3.fromHSV(H, S, V)
    end

    function Utility:EnableDragging(Frame, Parent)
        local DraggingInput, StartPosition
        local DragStart = Vector3.new(0, 0, 0)

        local Main = CoreGui:FindFirstChild("Visual Command UI Library")

        local function Update(Input)
            local Delta = Input.Positon - DragStart
            local Camera = Workspace.CurrentCamera

            if StartPosition.X.Offset + Delta.X <= -750 and -Camera.ViewportSize.X <= StartPosition.X.Offset + Delta.X then
                local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, Parent.Position.Y.Scale, Parent.Position.Y.Offset)
                Utility:Tween(Parent, {Position = Position}, 0.25)
            elseif StartPosition.X.Offset + Detla.X > -500 then
                local Position = UDim2.new(1, -250, Parent.Position.Y.Scale, Parent.Position.Y.Offset)
                Utility:Tween(Parent, {Position = Position}, 0.25)
            elseif -Camera.Viewport.Size.X > StartPosition.X.Offset + Delta.X then
                local Position = UDim2.new(1, -Camera.ViewportSize.X, Parent.Position.Y.Scale, Parent.Position.Y.Offset)
                Utility:Tween(Parent, {Position = Position}, 0.25)
            end
        end

        Frame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Parent.Position

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        Frame.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                DraggingInput = Input
            end
        end)

        UserInputService.InputChanged:Connect(function(Input)
            if Input == DraggingInput and Dragging then
                Update(Input)
            end
        end)
    end

    function Utility:StringToKeyCode(String)
        local Byte = string.byte(String)
        
        for _, KeyCode in next, Enum.KeyCode:GetEnumItems() do
            if KeyCode.Value == Byte then
                return KeyCode
            end
        end
    end

    function Utility:KeyCodeToString(KeyCode)
        if KeyCode.Value < 127 and KeyCode.Value > 33 then
            return string.char(KeyCode.Value)
        else
            return KeyCode.Name
        end
    end

    function Utility:GetProperty(Level, Name, Properties)
        local AllProperties = {
            Window = {
                --: Insert stuff here
            }
        }
    end
end