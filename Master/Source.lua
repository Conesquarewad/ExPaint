-- Service

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Player = game:GetService("Players").LocalPlayer

-- Variable

local Last = "v0.2α"
local Option = {
	Standard = Enum.Font.SourceSans,

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
		Label  = Color3.fromRGB(255, 255, 255),
		TextField = Color3.fromRGB(32, 32, 32),
		PlaceholderField = Color3.fromRGB(124, 124, 124),

		Titlebar = Color3.fromRGB(56, 59, 60),
		Sidebar = Color3.fromRGB(52, 54, 55),

		Background = Color3.fromRGB(69, 74, 75),

		Button = Color3.fromRGB(57, 59, 60),
		Field = Color3.fromRGB(248, 248, 248),
		Scrollbar = Color3.fromRGB(24, 25, 25),

		Outline = Color3.fromRGB(28, 29, 30)
	},
}

local Current = nil

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
			local Animated = Argument[2]
			
			if Animated == nil then Animated = true end

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
			local Dimmed = Argument[2]
			
			if Dimmed == nil then Dimmed = false end

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
			Field.PlaceholderColor3 = Option.Palette.PlaceholderField
			Field.TextScaled = true
			Field.TextWrapped = true
			Field.Font = Option.Standard
			Field.Size = UDim2.fromOffset(124, 32)
			Field.Text = Text
			Field.PlaceholderText = Placeholder

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
	} :: Element,

	["Box"] = {
		Class = "Box",

		Created = function(Argument : {any})
			local Target = Argument[1] or nil
			local Thickness = Argument[2] or 0.05
			local LineColor = Argument[3] or Color3.fromRGB(13, 105, 172)
			local SurfaceColor = Argument[4] or Color3.fromRGB(13, 105, 172)

			local Selection = Instance.new("SelectionBox")
			Selection.Name = "Selection"
			Selection.Transparency = 0
			Selection.SurfaceTransparency = 1
			Selection.Color3 = LineColor
			Selection.SurfaceColor3 = SurfaceColor
			Selection.LineThickness = Thickness
			Selection.Adornee = Target

			return Selection
		end
	} :: Element,
	
	["Frame"] = {
		Class = "Frame",
		
		Created = function(Argument : {any})
			local Size = Argument[1] or UDim2.fromOffset(124, 124)
			local Background = Argument[2] or Color3.fromRGB(255, 255, 255)
			local Border = Argument[3] or Color3.fromRGB(0, 0, 0)
			local Thickness = Argument[4] or 0
			
			local Frame = Instance.new("Frame")
			Frame.Name = "Frame"
			Frame.BackgroundColor3 = Background
			Frame.BorderColor3 = Border
			Frame.BorderSizePixel = Thickness
			Frame.Size = Size
			
			return Frame
		end
	} :: Element,
	
	["Scrolling"] = {
		Class = "Scrolling",

		Created = function(Argument : {any})
			local Size = Argument[1] or UDim2.fromOffset(124, 124)
			local Scrollbar = Argument[2]
			
			if Scrollbar == nil then Scrollbar = true end
			
			local Scrolling = Instance.new("ScrollingFrame")
			Scrolling.Name = "Scrolling"
			Scrolling.Size = Size
			Scrolling.BackgroundColor3 = Option.Palette.Background
			Scrolling.BorderColor3 = Option.Palette.Outline
			Scrolling.ScrollBarImageColor3 = Option.Palette.Scrollbar
			Scrolling.ScrollBarThickness = Scrollbar and 5 or 0
			Scrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
			
			Scrolling.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			Scrolling.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			Scrolling.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			
			Scrolling.ScrollBarImageTransparency = 0
			Scrolling.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
			
			return Scrolling
		end
	} :: Element,
	["Padding"] = {
		Class = "Padding",
		
		Created = function(Argument : {any})
			local Size = Argument[1] or 5
			
			local Padding = Instance.new("UIPadding")
			Padding.Name = "Padding"
			Padding.PaddingBottom = UDim.new(0, Size)
			Padding.PaddingLeft = UDim.new(0, Size)
			Padding.PaddingRight = UDim.new(0, Size)
			Padding.PaddingTop = UDim.new(0, Size)
			
			return Padding
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

local function HasTool()
	local Character = Player.Character or Player.CharacterAdded:Wait()

	if Character then

		if Character:FindFirstChildOfClass("Tool") then
			return true
		else
			return false
		end
	else
		return false
	end
end

local function Cast(Distance : number, Param : RaycastParams)
	local Camera = workspace.CurrentCamera

	if Camera then
		local Mouse = UserInputService:GetMouseLocation()
		local Unit = Camera:ViewportPointToRay( Mouse.X, Mouse.Y )

		local Raycast = workspace:Raycast( Unit.Origin, Unit.Origin + (Unit.Direction * Distance), Param )
		local Position = Unit.Origin + (Unit.Direction * Distance)

		if Raycast then
			Position = Raycast.Position

			return Position, Raycast
		else
			return Position, nil
		end
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

		local function Notify(Message : string, Tittle : string)
			StarterGui:SetCore("SendNotification", {
				Title = Tittle,
				Text = Message
			})
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
			
			Current = Instance.new("Color3Value")
			Current.Name = "Current"
			Current.Value = Color3.fromRGB(255, 0, 0)
			Current.Parent = Session

			local Main = Register("Dashboard")
			Main.Parent = Session

			local Activated = false

			local Display = Main:FindFirstChild("Display")

			local function CreateVisibility()
				Main:SetAttribute("Toggle", true)

				local Visibility = Register("Button", "<", false) :: TextButton
				Visibility.Name = "Visibility"
				Visibility.BackgroundTransparency = 1
				Visibility.Size = UDim2.fromScale(1, 1)

				Square().Parent = Visibility

				Visibility.Parent = Main.Sidebar

				local function Update()

					Visibility.Interactable = false

					if Main:GetAttribute("Toggle") then
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
					Main:SetAttribute("Toggle", not Main:GetAttribute("Toggle"))

					Update()
				end)

				return Visibility
			end

			local function CreateContent()
				local Task = {}

				-- Construction

				Register("Padding", 5).Parent = Display

				local Active do
					Active = Register("Button", "Active") :: TextButton
					Active.Name = "ActiveButton"
					Active.Text = Activated and "Deactive" or "Active"
					Active.Size = UDim2.new(1, -37, 0, 32)
					Active.Position = UDim2.fromScale(0, 1)
					Active.AnchorPoint = Vector2.new(0, 1)

					Active.Parent = Display
				end
				
				local Preview do
					Preview = Register("Frame", UDim2.fromOffset(32, 32)) :: Frame
					Preview.Name = "Preview"
					Preview.BackgroundColor3 = Current.Value
					Preview.BorderColor3 = Option.Palette.Outline
					Preview.Position = UDim2.fromScale(1, 1)
					Preview.AnchorPoint = Vector2.new(1, 1)
					Preview.BorderSizePixel = 1
					Preview.BorderMode = Enum.BorderMode.Inset
					Square().Parent = Preview
					Preview.Parent = Display
					
					local function Changed()
						Preview.BackgroundColor3 = Current.Value
					end
					
					Current:GetPropertyChangedSignal("Value"):Connect(Changed)
					Preview.Parent = Display
				end

				local Selector do
					Selector = Register("Box", nil, 0.05, Current.Value, Current.Value) :: SelectionBox
					Selector.Name = "Selector"
					Selector.Parent = Session
					Selector.SurfaceTransparency = 0.75
					
					local function Updated()
						Selector.Color3 = Current.Value
						Selector.SurfaceColor3 = Current.Value
					end
					
					Current:GetPropertyChangedSignal("Value"):Connect( Updated )
				end
				
				local Scrolling do
					Scrolling = Register("Scrolling", UDim2.new(1, 0, 1, -37) ) :: ScrollingFrame
					Scrolling.BackgroundTransparency = 1
					Scrolling.BorderSizePixel = 0
					Scrolling.CanvasSize = UDim2.fromScale(0, 0)
					Scrolling.Parent = Display
					
					local List = Instance.new("UIListLayout")
					List.Name = "List"
					List.FillDirection = Enum.FillDirection.Vertical
					List.HorizontalAlignment = Enum.HorizontalAlignment.Left
					List.VerticalAlignment = Enum.VerticalAlignment.Top
					List.Padding = UDim.new(0, 5)
					List.Parent = Scrolling
				end
				
				-- Color Input
				
				local RGBInput do
					RGBInput = Register("Field", "", "(0-255), (0-255), (0-255)") :: TextBox
					RGBInput.Name = "RGBInput"
					RGBInput.Size = UDim2.new(1, 0, 0, 32)
					RGBInput.Parent = Scrolling
					RGBInput.LayoutOrder = 1

					local function Input()
						local Text = RGBInput.Text

						if Text ~= "" then
							local Format = "^(%d+) *,+ *(%d+) *,+ *(%d+)"
							local A, B, C = Text:match( Format )

							if A and B and C then
								A = tonumber(A)
								B = tonumber(B)
								C = tonumber(C)

								if tonumber(A) and tonumber(B) and tonumber(C) then

									A = math.clamp( math.abs( math.floor(A) ), 0, 255 )
									B = math.clamp( math.abs( math.floor(B) ), 0, 255 )
									C = math.clamp( math.abs( math.floor(C) ), 0, 255 )

									if typeof(A) == "number" and typeof(B) == "number" and typeof(C) == "number" then
										local Updated = Color3.fromRGB(A, B, C)

										Current.Value = Updated
										
										RGBInput.Text = ("%s, %s, %s"):format( tostring(A),  tostring(B),  tostring(C))
									end
								end
							end
						end
					end
					
					local function Update()
						
						if not RGBInput:IsFocused() then
							local R, G, B = Current.Value.R, Current.Value.G, Current.Value.B
							
							R = math.clamp( math.abs( math.floor(R * 255) ), 0, 255 )
							G = math.clamp( math.abs( math.floor(G * 255) ), 0, 255 )
							B = math.clamp( math.abs( math.floor(B * 255) ), 0, 255 )
							
							RGBInput.Text = ("%s, %s, %s"):format( tostring(R),  tostring(G),  tostring(B))
						end
					end
					
					Current:GetPropertyChangedSignal("Value"):Connect(Update)
					RGBInput:GetPropertyChangedSignal("Text"):Connect(Input)
				end
				
				local HEXInput do
					HEXInput = Register("Field", "", "#FFFFFF") :: TextBox
					HEXInput.Name = "HEXInput"
					HEXInput.Size = UDim2.new(1, 0, 0, 32)
					HEXInput.Parent = Scrolling
					HEXInput.LayoutOrder = 2

					local function Input()
						local Text = HEXInput.Text

						if Text ~= "" then
							local Format = "^#?(%x%x%x%x%x%x)"
							local HEX = Text:match(Format)

							if HEX then
								HEX = HEX:lower()
								
								local Success, Result = pcall(function()
									Current.Value = Color3.fromHex( HEX )
								end)
								
								if Success then
									HEXInput.Text = string.format( "#%s", Current.Value:ToHex():upper() )
								end
							end
						end
					end

					local function Update()

						if not HEXInput:IsFocused() then
							local HEX = Current.Value:ToHex()
							
							HEXInput.Text = ("#%s"):format( HEX:upper() )
						end
					end

					Current:GetPropertyChangedSignal("Value"):Connect(Update)
					HEXInput:GetPropertyChangedSignal("Text"):Connect(Input)
				end

				-- Selector function

				local function Clicked()
					local Stuff = workspace:WaitForChild("Active")
					local Post = ReplicatedStorage:FindFirstChild("Post")

					if not Active and not Post then return end

					Activated = not Activated
					Active.Text = Activated and "Deactive" or "Active"

					Active.Interactable = false

					if not HasTool() then

						if Activated then
							local Filter = RaycastParams.new()
							Filter.FilterType = Enum.RaycastFilterType.Include
							Filter.FilterDescendantsInstances = { Stuff }
							Filter.IgnoreWater = true
							Filter.RespectCanCollide = false

							local function Move()

								if not HasTool() then
									local _, Result = Cast(2000, Filter)

									if Result then
										local Part = Result.Instance

										if Part:IsA("BasePart") then
											local Model = Part:FindFirstAncestorOfClass("Model")

											if Model then
												Selector.Adornee = Model
											else
												Selector.Adornee = Part
											end
										end
									else
										Selector.Adornee = nil
									end
								end
							end

							table.insert( Task, RunService.RenderStepped:Connect(function() 

								if UserInputService.MouseEnabled then
									Move()
								end
							end))

							table.insert( Task, UserInputService.InputBegan:Connect(function(Input, Processed) 

								if UserInputService.TouchEnabled then

									if Input.UserInputType == Enum.UserInputType.Touch then
										Move()
									end
								end

								if not Processed then

									if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then

										if Activated and not HasTool() then

											if Selector.Adornee then
												Post:FireServer( "Paint", Selector.Adornee, Current.Value )
											end
										end

									end
								end
							end))

							for _, Item in pairs( Task ) do

								if not table.find( Connector, Item ) then
									AddConnector( Item )
								end
							end
						else

							for _, Item in pairs( Task ) do

								if table.find( Connector, Item ) then
									RemoveConnector( Item )
								end
							end

							table.clear( Task )
						end
					else
						Selector.Adornee = nil
					end

					Active.Interactable = true
				end

				Active.MouseButton1Click:Connect( Clicked )
			end

			CreateVisibility()
			CreateContent()

			Session.Parent = Root
		end
	end
end

Init()
