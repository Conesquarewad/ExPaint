local Registry = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Register Type

export type Element = {
	Class : Classes,

	Mounted : (Theme : Theme, Argument : { any }) -> Instance,
}

export type Classes = 
	| "Button"
	| "Field"
	| "Label"
	| "Scroll"
-- INDEV | "Checkbox"
	| "Spinner"
-- INDEV | "Dropdown"
-- INDEV | "ToggleSwitch"
	| "ProgressBar"
	| "Dashboard"

export type Theme = {
	Standard : Font,

	Scale : {
		Bigger : number,
		Default : number,
		Small : number
	},

	Easing : {
		Slow : TweenInfo,
		Medium : TweenInfo,
		Fast : TweenInfo
	},

	Palette : {
		Scheme : Color3,
		Label : Color3,

		TextField : Color3,
		TextPlaceholder : Color3,

		Titlebar : Color3,
		Sidebar : Color3,

		Background : Color3,

		Button : Color3,
		Field : Color3,
		Scrollbar : Color3,
		Knob : Color3,

		Outline : Color3
	}
}

-- Register default data

Registry.Present = {
	Standard = Font.new(
		"rbxasset://fonts/families/SourceSansPro.json",
		Enum.FontWeight.Regular,
		Enum.FontStyle.Normal
	),

	Scale = {
		Bigger = 32,
		Default = 24,
		Small = 14
	},

	Easing = {
		Slow = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		Medium = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		Fast = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
	},

	Palette = {
		Scheme = Color3.fromRGB(255, 255, 255),

		Label  = Color3.fromRGB(255, 255, 255),
		TextField = Color3.fromRGB(32, 32, 32),
		TextPlaceholder = Color3.fromRGB(124, 124, 124),

		Titlebar = Color3.fromRGB(56, 59, 60),
		Sidebar = Color3.fromRGB(61, 64, 65),

		Background = Color3.fromRGB(69, 74, 75),

		Button = Color3.fromRGB(57, 59, 60),
		Field = Color3.fromRGB(255, 255, 255),
		Scrollbar = Color3.fromRGB(24, 25, 25),
		Knob = Color3.fromRGB(235, 235, 235),

		Outline = Color3.fromRGB(28, 29, 30)
	},
} :: Theme

-- Function

function Registry.New(Class : Classes, Theme : Theme? , ...)
	Theme = Theme or Registry.Present
	local Argument = { ... }
	local Needle = nil

	for _, Element : Element in pairs( Registry.Component ) do

		if string.lower( Element.Class ) == string.lower( Class ) then
			Needle = Element
		end
	end

	if Needle then
		local After = Needle.Mounted(Theme, Argument)

		if After then
			return After
		else
			warn("Yield of mounting can't be empty")
		end
	else
		warn( ("Unable to create '%s' class"):format( Class ) )
	end
end


function Registry.CreateTextSize(Max : number, Parent : Instance?)
	Parent = Parent or nil

	local Constraint = Instance.new("UITextSizeConstraint")

	Constraint.MaxTextSize = Max
	Constraint.MinTextSize = 1

	Constraint.Parent = Parent

	return Constraint
end

function Registry.CreatePadding(Thickness : number, Parent : Instance?)
	Parent = Parent or nil

	local Constraint = Instance.new("UIPadding")

	Constraint.PaddingBottom = UDim.new(0, Thickness)
	Constraint.PaddingLeft = UDim.new(0, Thickness)
	Constraint.PaddingRight = UDim.new(0, Thickness)
	Constraint.PaddingTop = UDim.new(0, Thickness)

	Constraint.Parent = Parent

	return Constraint
end

function Registry.CreateList(Padding : number, Direction : Enum.FillDirection, Parent : Instance?)
	Parent = Parent or nil

	local List = Instance.new("UIListLayout")
	List.Padding = UDim.new(0, Padding)

	List.FillDirection = Direction

	List.SortOrder = Enum.SortOrder.LayoutOrder

	List.HorizontalAlignment = Enum.HorizontalAlignment.Left
	List.VerticalAlignment = Enum.VerticalAlignment.Top

	List.Parent = Parent

	return List
end

function Registry.CreateFlex(Mode : Enum.UIFlexMode, Parent : Instance?)
	Parent = Parent or nil

	local Flex = Instance.new("UIFlexItem")
	Flex.FlexMode = Enum.UIFlexMode.Fill
	Flex.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	Flex.Parent = Parent

	return Flex
end

function Registry.CreateRatio(Ratio : number, Parent : Instance?)
	Parent = Parent or nil

	local Constraint = Instance.new("UIAspectRatioConstraint")
	Constraint.AspectRatio = Ratio
	Constraint.AspectType = Enum.AspectType.FitWithinMaxSize

	Constraint.DominantAxis = Enum.DominantAxis.Width

	Constraint.Parent = Parent

	return Constraint
end


Registry.Component = {

	-- Button
	[1] = {
		Class = "Button",

		Mounted = function(Theme, Argument)
			local Text = Argument[1] or "Button"
			local Plain = if Argument[2] == nil then false else Argument[1]

			local Button = Instance.new("TextButton")
			Button.Name = "Button"

			Button.BackgroundColor3 = Theme.Palette.Button
			Button.BorderColor3 = Theme.Palette.Outline

			Button.BorderSizePixel = 0

			Button.TextColor3 = Theme.Palette.Label

			Button.TextScaled = true
			Button.TextWrapped = true
			Button.Text = Text

			Button.FontFace = Theme.Standard

			Button.Size = UDim2.fromOffset(124, 32)

			Button:SetAttribute("Plain", Plain)

			local function Update()
				local State = Button.GuiState

				if not Button:GetAttribute("Plain") then

					if Button.GuiState == Enum.GuiState.NonInteractable then
						local Tween = TweenService:Create(Button, Theme.Easing.Medium, {
							TextTransparency = 0.5
						} ) 

						Tween:Play()
					else
						local Tween = TweenService:Create(Button, Theme.Easing.Medium, {
							TextTransparency = 0
						} ) 

						Tween:Play()
					end
				end
			end

			Button:GetPropertyChangedSignal("GuiState"):Connect(Update)
			Button:GetAttributeChangedSignal("Plain"):Connect(Update)

			Registry.CreateTextSize( Theme.Scale.Default, Button )

			return Button
		end,
	} :: Element,

	-- Field
	[2] = {
		Class = "Field",

		Mounted = function(Theme, Argument)
			local Text = Argument[1] or ""
			local Placeholder = Argument[2] or "Field"

			local Field = Instance.new("TextBox")
			Field.Name = "Field"

			Field.BackgroundColor3 = Theme.Palette.Field
			Field.BorderColor3 = Theme.Palette.Outline

			Field.BorderSizePixel = 0

			Field.TextColor3 = Theme.Palette.TextField
			Field.PlaceholderColor3 = Theme.Palette.TextPlaceholder

			Field.BorderSizePixel = 0

			Field.TextScaled = true
			Field.TextWrapped = true

			Field.Text = Text
			Field.PlaceholderText = Placeholder

			Field.ClearTextOnFocus = false

			Field.FontFace = Theme.Standard

			Field.Size = UDim2.fromOffset(124, 32)

			Registry.CreateTextSize(Theme.Scale.Default, Field)

			local function Update()
				local State = Field.GuiState

				if State == Enum.GuiState.NonInteractable then
					local Tween = TweenService:Create(Field, Theme.Easing.Medium, {
						TextTransparency = 0.5
					})

					Tween:Play()
				else
					local Tween = TweenService:Create(Field, Theme.Easing.Medium, {
						TextTransparency = 0
					})

					Tween:Play()
				end
			end

			Field:GetPropertyChangedSignal("GuiState"):Connect(Update)

			return Field
		end,
	} :: Element,

	-- Scroll
	[3] = {
		Class = "Scroll",

		Mounted = function(Theme, Argument)
			local Square = "rbxasset://textures/ui/Scroll/scroll-middle.png"

			local Size = Argument[1] or UDim2.fromOffset(124, 124)
			local Scrollbar = if Argument[2] == nil then true else Argument[1]

			local Scroll = Instance.new("ScrollingFrame")
			Scroll.Name = "Scroll"

			Scroll.BackgroundColor3 = Theme.Palette.Background
			Scroll.BorderColor3 = Theme.Palette.Outline

			Scroll.BorderSizePixel = 0

			Scroll.ScrollBarImageColor3 = Theme.Palette.Scrollbar
			Scroll.ScrollBarImageTransparency = 0.25
			Scroll.ScrollBarThickness = Scrollbar and 5 or 0

			Scroll.TopImage = Square
			Scroll.BottomImage = Square
			Scroll.MidImage = Square

			Scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

			Scroll.AutomaticSize = Enum.AutomaticSize.Y

			return Scroll
		end,
	} :: Element,

	-- ProgressBar

	[4] = {
		Class = "ProgressBar",

		Mounted = function(Theme, Argument)
			local Progress = Argument[1] or 50
			local Range = Argument[2] or NumberRange.new(0, 100)

			local Main = Instance.new("Frame")
			Main.Name = "ProgressBar"

			Main.BackgroundColor3 = Theme.Palette.Button
			Main.BorderColor3 = Theme.Palette.Outline

			Main.BorderSizePixel = 0
			Main.Size = UDim2.fromOffset(124, 32)

			Main:SetAttribute("Progress", Progress)
			Main:SetAttribute("Range", Range)

			Registry.CreatePadding(1, Main)

			local Fill = Instance.new("Frame")
			Fill.Name = "Fill"

			Fill.BackgroundColor3 = Theme.Palette.Scheme
			Fill.BorderColor3 = Theme.Palette.Outline

			Fill.BorderSizePixel = 0
			Fill.Size = UDim2.fromScale(0.5 ,1)

			Fill.Parent = Main

			local function Update()
				local State = Main.GuiState

				local Tween1 = TweenService:Create(Fill, Theme.Easing.Medium, {
					Size = UDim2.fromScale( math.clamp( Main:GetAttribute("Progress"), Main:GetAttribute("Range").Min, Main:GetAttribute("Range").Max ) / Main:GetAttribute("Range").Max , 1)
				})

				Tween1:Play()

				if State == Enum.GuiState.NonInteractable then
					local Tween2 = TweenService:Create(Fill, Theme.Easing.Medium, {
						BackgrondTransparency = 0.5
					})

					Tween2:Play()
				else
					local Tween2 = TweenService:Create(Fill, Theme.Easing.Medium, {
						BackgroundTransparency = 0
					})

					Tween2:Play()
				end
			end

			Update()

			Main:GetAttributeChangedSignal("Range"):Connect(Update)
			Main:GetAttributeChangedSignal("Progress"):Connect(Update)
			Main:GetPropertyChangedSignal("GuiState"):Connect(Update)

			return Main
		end,
	} :: Element,

	-- Spinner

	[5] = {
		Class = "Spinner",

		Mounted = function(Theme, Argument)
			local Number = Argument[1] or 5
			local Range = Argument[2] or NumberRange.new(0, 10)
			local Increment = Argument[3] or 1

			local Connections = {}

			local Main = Instance.new("Frame")
			Main.Name = "Spinner"

			Main.BackgroundColor3 = Theme.Palette.Button
			Main.BorderColor3 = Theme.Palette.Outline

			Main.BorderSizePixel = 0
			Main.Size = UDim2.fromOffset(124, 32)

			Main:SetAttribute("Value", Number)
			Main:SetAttribute("Range", Range)
			Main:SetAttribute("Increment", Increment)

			Registry.CreatePadding(1, Main)
			Registry.CreateList(1, Enum.FillDirection.Horizontal, Main)

			local function Clear()

				for _, Connection in pairs( Connections ) do

					if typeof( Connection ) == "RBXScriptConnection" then
						Connection:Disconnect()
					elseif typeof( Connection ) == "thread" then
						task.cancel( Connection )
					elseif typeof( Connection ) == "Instance" then
						Connection:Destroy()
					end
				end

				table.clear( Connections )
			end


			local Field do
				Field = Registry.New("Field", Theme, tostring( Number ), "Number") :: TextBox
				Field.Name = "Input"
				Field.LayoutOrder = 1

				Field.Size = UDim2.fromScale(0, 1)

				Registry.CreateFlex(Enum.UIFlexMode.Fill, Field)

				local function Lost(Enter : boolean)
					local Text = Field.Text

					if Enter then
						local Current = Main:GetAttribute("Value")

						if Current and typeof(Current) == "number" then
							local Number = tonumber( Text )

							if Number then
								Field.Text = tostring( Number )

								Main:SetAttribute("Value", Number)
							else
								Field.Text = tostring( Current )
							end
						end
					end
				end

				local function InputChanged(Input : InputObject)

					if Input.UserInputType == Enum.UserInputType.MouseWheel then

						if not Field:IsFocused() then
							local Z = Input.Position.Z

							local Current = Main:GetAttribute("Value")
							local Multiply = Main:GetAttribute("Increment")

							Main:SetAttribute("Value", Current + (Multiply * Z ) )
						end
					end
				end

				Field.FocusLost:Connect(Lost)
				Field.Focused:Connect(Clear)
				Field.MouseEnter:Connect(function()

					if not Field:IsFocused() then
						table.insert( Connections, UserInputService.InputChanged:Connect(InputChanged) )
					end
				end)
				Field.MouseLeave:Connect(Clear)

				Field.Parent = Main
			end

			local Side do
				Side = Instance.new("Frame")
				Side.LayoutOrder = 2

				Side.BackgroundColor3 = Theme.Palette.Sidebar
				Side.BorderColor3 = Theme.Palette.Outline

				Side.BorderSizePixel = 0
				Side.Size = UDim2.new(0, 16, 1, 0)

				Registry.CreateList(0, Enum.FillDirection.Vertical, Side)

				local Table = {
					[1] = {
						Name = "Increase",
						Display = "▲",
						Amount = "Up"
					},
					[2] = {
						Name = "Decrease",
						Display = "▼",
						Amount = "Down"
					}
				}

				for Index, Item in pairs( Table ) do
					local Button = Registry.New("Button", Theme, Item.Display) :: TextButton
					Button.Name = Item.Name
					Button.LayoutOrder = Index

					Button.BackgroundTransparency = 1

					Button.Size = UDim2.fromScale(1, 0)

					Registry.CreateFlex(Enum.UIFlexMode.Fill, Button)

					local Constraint = Button:FindFirstAncestorWhichIsA("UITextSizeConstraint")

					if Constraint then
						Constraint.MaxTextSize = Theme.Scale.Small
					end

					local function Clicked()
						local Current = Main:GetAttribute("Value")
						local Multiply = Main:GetAttribute("Increment")

						if Current then
							Main:SetAttribute("Value", Current + if Item.Amount:lower() == "up" then Increment else -Increment)
						end
					end

					Button.MouseButton1Click:Connect(Clicked)
					Button.Parent = Side
				end

				Side.Parent = Main
			end

			local Debounce = false

			local function Update()

				if not Debounce then
					Debounce = true

					local Value = Main:GetAttribute("Value")
					local Limit = Main:GetAttribute("Range")

					if Value and Limit then

						if typeof(Value) == "number" and typeof(Limit) == "NumberRange" then

							if not Field:IsFocused() then
								local Cap = tostring( math.clamp( Value, Limit.Min, Limit.Max ) )

								Field.Text = tostring(Cap)
								Main:SetAttribute("Value", Cap)
							end
						end
					end

					Debounce = false
				end

			end

			Main:GetAttributeChangedSignal("Value"):Connect(Update)
			Main:GetAttributeChangedSignal("Range"):Connect(Update)

			return Main
		end,
	} :: Element,

	-- Label

	[6] = {
		Class = "Label",

		Mounted = function(Theme, Argument)
			local Text = Argument[1] or "The quick brown fox jumps over the lazy dog"
			local RichText = if Argument[2] == nil then false else Argument[2]

			local Label = Instance.new("TextLabel")
			Label.Name = "Label"

			Label.BackgroundColor3 = Theme.Palette.Background
			Label.BorderColor3 = Theme.Palette.Outline

			Label.BackgroundTransparency = 1

			Label.BorderSizePixel = 0

			Label.TextColor3 = Theme.Palette.Label

			Label.TextScaled = true
			Label.TextWrapped = true
			Label.RichText = RichText
			Label.FontFace = Theme.Standard

			Label.Size = UDim2.fromOffset(124, 32)
			
			Label.Text = Text

			Registry.CreateTextSize(Theme.Scale.Default, Label)

			return Label
		end,
	} :: Element,

	-- Dashboard

	[7] = {
		Class = "Dashboard",

		Mounted = function(Theme, Argument)
			local Title = Argument[1] or "<b><i>Ex</i>Painter</b>"
			local Last = Argument[2] or "<Version>"
			local Size = Argument[3] or UDim2.fromOffset(275, 250)

			local Main = Instance.new("Frame")
			Main.Name = "Dashboard"

			Main.BackgroundColor3 = Theme.Palette.Background
			Main.BorderColor3 = Theme.Palette.Outline

			Main.BorderSizePixel = 0
			Main.Size = Size
			
			local Outline = Instance.new("UIStroke")
			Outline.Name = "Outline"
			
			Outline.LineJoinMode = Enum.LineJoinMode.Miter
			Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			
			Outline.Thickness = 1
			Outline.Transparency = 0.75
			
			Outline.Color = Theme.Palette.Outline
			
			Outline.Parent = Main
			

			local Titlebar do
				Titlebar = Registry.New("Label", Theme, Title, true) :: TextLabel
				Titlebar.Name = "Titlebar"

				Titlebar.BackgroundColor3 = Theme.Palette.Titlebar
				Titlebar.BorderColor3 = Theme.Palette.Outline

				Titlebar.BackgroundTransparency = 0

				Titlebar.Position = UDim2.fromScale(0, 0)
				Titlebar.Size = UDim2.new(1, 0, 0, 32)

				Titlebar.ZIndex = 2

				Registry.CreatePadding(5, Titlebar)

				local Lastest do 
					Lastest = Registry.New("Label", Theme, Last) :: TextButton
					Lastest.Name = "About"

					Lastest.BackgroundColor3 = Theme.Palette.Titlebar
					Lastest.BorderColor3 = Theme.Palette.Outline

					Lastest.TextTransparency = 0.5
					Lastest.TextStrokeTransparency = 1

					Lastest.AnchorPoint = Vector2.new(1, 0)

					Lastest.Position = UDim2.new(1, 5, 0, -5)
					Lastest.Size = UDim2.fromOffset(32, 32)

					Lastest.Parent = Titlebar
				end

				Titlebar.Parent = Main
			end

			local Toolbar do
				Toolbar = Instance.new("Frame")
				Toolbar.Name = "Toolbar"

				Toolbar.BackgroundColor3 = Theme.Palette.Sidebar
				Toolbar.BorderColor3 = Theme.Palette.Outline

				Toolbar.BorderSizePixel = 0

				Toolbar.Size = UDim2.new(1, -32, 0, 32)
				Toolbar.Position = UDim2.fromOffset(0, 32)
				

				Toolbar.ZIndex = 2

				Registry.CreateList(0, Enum.FillDirection.Horizontal, Toolbar)

				Toolbar.Parent = Main
			end

			local Sidebar do
				Sidebar = Instance.new("Frame")
				Sidebar.Name = "Sidebar"

				Sidebar.BackgroundColor3 = Theme.Palette.Sidebar
				Sidebar.BorderColor3 = Theme.Palette.Outline

				Sidebar.BorderSizePixel = 0

				Sidebar.Size = UDim2.new(0, 32, 1, -32)
				Sidebar.Position = UDim2.new(1, 0, 0, 32)

				Sidebar.ZIndex = 2

				Sidebar.AnchorPoint = Vector2.new(1, 0)

				Registry.CreateList(0, Enum.FillDirection.Vertical, Sidebar)

				Sidebar.Parent = Main
			end

			local Display do
				Display = Instance.new("Frame")
				Display.Name = "Display"

				Display.BackgroundColor3 = Theme.Palette.Background
				Display.BorderColor3 = Theme.Palette.Outline
				
				Display.BackgroundTransparency = 1

				Display.BorderSizePixel = 0

				Display.Size = UDim2.new(1, -32, 1, -64)
				Display.Position = UDim2.fromScale(0, 1)

				Display.ZIndex = 1

				Display.AnchorPoint = Vector2.new(0, 1)

				Registry.CreateList(0, Enum.FillDirection.Vertical, Display)

				Display.Parent = Main
			end
			
			return Main
		end,
	} :: Element
}

return Registry
