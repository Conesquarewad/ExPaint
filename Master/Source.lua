-- Service

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Player = game:GetService("Players").LocalPlayer

-- Variable

local Last = "v0.1α"
local Option = {
	Standard = Enum.Font.SourceSans,

	Scale = {
		Bigger = 32,
		Default = 24,
		Small = 14
	},w

	Easing = {
		Slow = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		Medium = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		Fast = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
	},

	Palette = {
		Label  = Color3.fromRGB(255, 255, 255),
		TextField = Color3.fromRGB(32, 32, 32),

		Titlebar = Color3.fromRGB(56, 59, 60),
		Sidebar = Color3.fromRGB(52, 54, 55),

		Background = Color3.fromRGB(69, 74, 75),

		Button = Color3.fromRGB(57, 59, 60),
		Field = Color3.fromRGB(248, 248, 248),
		Scrollbar = Color3.fromRGB(24, 25, 25),

		Outline = Color3.fromRGB(28, 29, 30)
	},

	Default = Color3.fromRGB(63, 72, 204)
}

local Connector = {}
local Session

-- Registry

type Element = {
	Class : string,
	Created : (Argument : { any }) -> Instance,
}

local Elements = {
	["Button"] = {
		Class = "Button",
		
		Created = function(Argument : { any })
			local Text = Argument[1] or "Button"
			local Animated = Argument[2] or true

			local Button = Instance.new("TextButton")
			Button.Name = "Button"
			Button.BackgroundColor3 = Option.Palette.Button
			Button.BorderColor3 = Option.Palette.Outline
			Button.BorderSizePixel = 0
			Button.TextColor3 = Option.Palette.Label
			Button.TextScaled = true
			Button.TextWrapped = true
			Button.Font = Option.Standard
			Button.Size = UDim2.fromOffset(124, 32)
			Button.Text = Text

			local function Update()
				local Interactable = Button.Interactable

				if Interactable then
					local Tween = TweenService:Create(Button, Option.Easing.Medium, {
						TextTransparency = 0
					})

					Tween:Play()
				else
					local Tween = TweenService:Create(Button, Option.Easing.Medium, {
						TextTransparency = 0.5
					})

					Tween:Play()
				end
			end

			if Animated then
				Update()

				Button:GetPropertyChangedSignal("Interactable"):Connect(Update)
			end

			local Scale = Instance.new("UITextSizeConstraint")
			Scale.Name = "Limit"
			Scale.Parent = Button
			Scale.MaxTextSize = Option.Scale.Default

			return Button
		end
	} :: Element,
	
	["Label"] = {
		Class = "Label",
		
		Created = function(Argument : {any})
			local Text = Argument[1] or "Foo bar baz"
			local Dimmed = Argument[2] or false

			local Label = Instance.new("TextLabel")
			Label.Name = "Label"
			Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label.BackgroundTransparency = 1
			Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label.BorderSizePixel = 0
			Label.TextColor3 = Option.Palette.Label
			Label.TextScaled = true
			Label.TextWrapped = true
			Label.Font = Option.Standard
			Label.Size = UDim2.fromOffset(124, 32)
			Label.Text = Text

			Label:SetAttribute("Dimmed", Dimmed)

			local function Update()
				local IsDimmed = Label:GetAttribute("Dimmed")

				if IsDimmed then
					local Tween = TweenService:Create(Label, Option.Easing.Medium, {
						TextTransparency = 0.5
					})

					Tween:Play()
				else
					local Tween = TweenService:Create(Label, Option.Easing.Medium, {
						TextTransparency = 0
					})

					Tween:Play()
				end
			end

			local Scale = Instance.new("UITextSizeConstraint")
			Scale.Name = "Limit"
			Scale.Parent = Label
			Scale.MaxTextSize = Option.Scale.Default

			Update()

			Label:GetAttributeChangedSignal("Dimmed"):Connect(Update)

			return Label
		end,
	} :: Element,
	["Field"] = {
		Class = "Field",
		
		Created = function(Argument : {any})
			local Text = Argument[1] or "Foo bar baz"
			local Placeholder = Argument[2] or ""

			local Field = Instance.new("TextBox")
			Field.Name = "Field"
			Field.BackgroundColor3 = Option.Palette.Field
			Field.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Field.BorderSizePixel = 0
			Field.TextColor3 = Option.Palette.TextField
			Field.TextScaled = true
			Field.TextWrapped = true
			Field.Font = Option.Standard
			Field.Size = UDim2.fromOffset(124, 32)
			Field.Text = Text

			local function Update()
				local Interactable = Field.Interactable

				if Interactable then
					local Tween = TweenService:Create(Field, Option.Easing.Medium, {
						TextTransparency = 0
					})

					Tween:Play()
				else
					local Tween = TweenService:Create(Field, Option.Easing.Medium, {
						TextTransparency = 0.5
					})

					Tween:Play()
				end
			end

			local Scale = Instance.new("UITextSizeConstraint")
			Scale.Name = "Limit"
			Scale.Parent = Field
			Scale.MaxTextSize = Option.Scale.Default

			Update()

			Field:GetPropertyChangedSignal("Interactable"):Connect(Update)
			
			return Field
		end,
	} :: Element,
	
	["Dashboard"] = {
		Class = "Dashboard",
		
		Created = function(Argument : {any})
			local function CreateTextsize(Size : number)
				local Scale = Instance.new("UITextSizeConstraint")
				Scale.Name = "Limit"
				Scale.MaxTextSize = Size
				
				return Scale
			end
			
			local Title = Argument[1] or "<b><i>Ex</i></b>Painter"
			local Size = Argument[2] or Vector2.new(300, 200)
			
			local Main = Instance.new("Frame")
			Main.Name = "Dashboard"
			Main.BackgroundColor3 = Option.Palette.Background
			Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Main.BorderSizePixel = 0
			Main.Size = UDim2.fromOffset( Size.X, Size.Y )
			Main.AnchorPoint = Vector2.new(0, 0.5)
			Main.Position = UDim2.fromScale(0, 0.5)
			
			local Outline = Instance.new("UIStroke")
			Outline.Name = "Outline"
			Outline.Color = Option.Palette.Outline
			Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Outline.LineJoinMode = Enum.LineJoinMode.Miter
			Outline.Thickness = 1
			Outline.Transparency = 0.75
			Outline.Parent = Main
			
			local Titlebar = Instance.new("TextLabel")
			Titlebar.Name = "Titlebar"
			Titlebar.Font = Option.Standard
			Titlebar.TextColor3 = Option.Palette.Label
			Titlebar.BackgroundColor3 = Option.Palette.Titlebar
			Titlebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Titlebar.Text = Title
			Titlebar.TextScaled = true
			Titlebar.TextWrapped = true
			Titlebar.RichText = true
			Titlebar.BorderSizePixel = 0
			Titlebar.Size = UDim2.new(1, 0, 0, 32)
			Titlebar.ZIndex = 2
			Titlebar.Parent = Main
			
			CreateTextsize( Option.Scale.Default ).Parent = Titlebar
			
			do
				local Padding = Instance.new("UIPadding")
				Padding.PaddingBottom = UDim.new(0, 5)
				Padding.PaddingLeft = UDim.new(0, 5)
				Padding.PaddingRight = UDim.new(0, 5)
				Padding.PaddingTop = UDim.new(0, 5)
				Padding.Parent = Titlebar
				
				local VersionLabel = Instance.new("TextLabel")
				VersionLabel.Name = "Version"
				VersionLabel.Font = Option.Standard
				VersionLabel.TextColor3 = Option.Palette.Label
				VersionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				VersionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				VersionLabel.BorderSizePixel = 0
				VersionLabel.BackgroundTransparency = 1
				VersionLabel.TextTransparency = 0.5
				VersionLabel.TextScaled = true
				VersionLabel.TextWrapped = true
				VersionLabel.Text = Last
				VersionLabel.AnchorPoint = Vector2.new(1, 0)
				VersionLabel.Position = UDim2.new(1, 5, 0, -5)
				VersionLabel.Size = UDim2.fromOffset(32, 32)
				VersionLabel.Parent = Titlebar
				
				CreateTextsize( Option.Scale.Small ).Parent = VersionLabel
			end
			
			local Sidebar = Instance.new("Frame")
			Sidebar.Name = "Sidebar"
			Sidebar.BackgroundColor3 = Option.Palette.Sidebar
			Sidebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Sidebar.BorderSizePixel = 0
			Sidebar.Size = UDim2.new(0, 32, 1, -32)
			Sidebar.Position = UDim2.new(1, 0, 0, 32)
			Sidebar.AnchorPoint = Vector2.new(1, 0)
			Sidebar.ZIndex = 2
			Sidebar.Parent = Main
			
			do
				local List = Instance.new("UIListLayout")
				List.Name = "List"
				List.Padding = UDim.new(0, 0)
				List.FillDirection = Enum.FillDirection.Vertical
				List.HorizontalAlignment = Enum.HorizontalAlignment.Left
				List.VerticalAlignment = Enum.VerticalAlignment.Top
				List.Parent = Sidebar
			end
			
			local Display = Instance.new("Frame")
			Display.Name = "Display"
			Display.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Display.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Display.BorderSizePixel = 0
			Display.Position = UDim2.fromScale(0, 1)
			Display.Size = UDim2.new(1, -32, 1, -32)
			Display.BackgroundTransparency = 1
			Display.AnchorPoint = Vector2.new(0, 1)
			Display.Parent = Main
			
			return Main
		end
	} :: Element
}

local function Register(Type : string, ...)
	local Argument = { ... }
	local Result = {}

	for _, Registry in pairs( Elements ) do
		local Class, Created = Registry.Class, Registry.Created
		
		if Class and Created then
			
			if string.lower( Type ) == string.lower( Class )  then
				Result = Registry
				
				break
			else
				Result = nil :: never
			end
		end
	end
	
	if Result then
		local Created = Result["Created"]
		
		if Created and typeof(Created) == "function" then
			return Created(Argument) :: Instance
		end
	else
		warn("Invaild type")
		
		return
	end
end


-- Connector management

local function AddConnector(Object : RBXScriptConnection | thread | Instance)

	if not table.find(Connector, Object) then
		table.insert(Connector, Object)
	else
		warn("Object in connect is already exist.")
	end
end

local function RemoveConnector(Object : RBXScriptConnection | thread | Instance)

	if table.find(Connector, Object) then
		local Found = Connector[ table.find(Connector, Object) :: number ]

		if Found then

			if typeof(Found) == "RBXScriptConnection" then
				Found:Disconnect()
			elseif typeof(Found) == "thread" then
				task.cancel(Found)
			elseif typeof(Found) == "Instance" then
				Found:Destroy()
			end

			table.remove( Connector, table.find(Connector, Object) )
		else
			warn("Object is not found.")
		end
	else
		warn("Object is not connected.")
	end
end

local function Terminate()

	if Session then

		if typeof(Session) == "Instance" then
			Session:Destroy()
		end
	end

	for _, Connection in pairs(Connector) do
		RemoveConnector( Connection )
	end
end

-- Miscellaneous

local function HasAccessCoreGui()
	local Success, Result = pcall(function()
		return game:GetService("CoreGui").Name
	end)

	if Success then
		return true
	else
		return false
	end
end

-- Master

local function Init()

	if Player and Player:IsDescendantOf( game:GetService("Players") ) then

		local Root do
			if HasAccessCoreGui() then
				Root = game:GetService("CoreGui")
			else
				Root = Player:WaitForChild("PlayerGui")
			end
		end


		local function FindSession()
			return Root:FindFirstChild( ("__EXPAINTER_%d__"):format(Player.UserId) )
		end

		if FindSession() then
			warn("This user already have.")

			return
		else
			local function Square()
				local Ratio = Instance.new("UIAspectRatioConstraint")
				Ratio.Name = "Ratio"
				Ratio.AspectRatio = 1
				
				return Ratio
			end
			
			Session = Instance.new("ScreenGui")
			Session.Name = ("__EXPAINTER_%d__"):format(Player.UserId)
			Session.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			Session.IgnoreGuiInset = false
			Session.ResetOnSpawn = false
			Session.DisplayOrder = 10
			
			local Toggle = true
			
			local Main = Register("Dashboard")
			Main.Parent = Session
			
			local Visibility = Register("Button", "<", false)
			Visibility.Name = "Visibility"
			Visibility.BackgroundTransparency = 1
			Visibility.Size = UDim2.fromScale(1, 1)
			
			Square().Parent = Visibility
			
			Visibility.Parent = Main.Sidebar
			
			local function Update()
				
				Visibility.Interactable = false
				
				if Toggle then
					Visibility.Text = ">"
					
					local Tween = TweenService:Create(Main, Option.Easing.Medium, {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(0, 32, 0.5, 0)
					} )
					
					Tween:Play()
					Tween.Completed:Wait()
				else
					Visibility.Text = "<"
					
					local Tween = TweenService:Create(Main, Option.Easing.Medium, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 5, 0.5, 0)
					} )
					
					
					Tween:Play()
					Tween.Completed:Wait()
				end
				
				Visibility.Interactable = true
			end
			
			Main.AnchorPoint = Vector2.new(1, 0.5)
			Main.Position = UDim2.new(0, 32, 0.5, 0)
			
			Update()
			
			Visibility.MouseButton1Click:Connect(function()
				Toggle = not Toggle
				
				Update()
			end)
			
			Session.Parent = Root
		end
	end
end

Init()