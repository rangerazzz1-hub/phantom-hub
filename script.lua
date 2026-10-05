--[[
	PHANTOM HUB - v6.0
	- Abertura "By Phantom"
	- Painel do Dono (Ligar/Parar/Reiniciar)
	- 😶 //render
	- ☠️ .Mira 🎯:: Cabeça `` Disparo (MAT) — {DEITA}
	- 🎯 ./atira no Pneu
	- 👑 Finalizar — Peaky Blinders! 👑
	- 👁️ Esconde/Mostra os botões
	- Tela de manutenção quando o hub para
]]

-- ============================================
-- SERVIÇOS
-- ============================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- CONFIGURAÇÃO
-- ============================================
local CONFIG = {
	TamanhoBotao = UDim2.new(0, 42, 0, 42),
	TamanhoHover = UDim2.new(0, 46, 0, 46),
	TamanhoClique = UDim2.new(0, 50, 0, 50),
	CorFundo = Color3.fromRGB(35, 35, 35),
	CorFundoHover = Color3.fromRGB(45, 45, 45),
	CorFundoClique = Color3.fromRGB(60, 60, 60),
	CorTexto = Color3.fromRGB(255, 255, 255),
	TempoAnimacao = 0.15,
	CorPhantom = Color3.fromRGB(150, 100, 255),
}

-- ============================================
-- ESTADO GLOBAL
-- ============================================
local Estado = {
	Ativo = false,
	ScreenGui = nil,
	Conexoes = {},
	PainelManutencao = nil,
}

-- ============================================
-- ABERTURA "BY PHANTOM"
-- ============================================
local function mostrarAbertura()
	local splashGui = Instance.new("ScreenGui")
	splashGui.Name = "AberturaPhantom"
	splashGui.ResetOnSpawn = false
	splashGui.IgnoreGuiInset = true
	splashGui.DisplayOrder = 999
	splashGui.Parent = playerGui

	local fundo = Instance.new("Frame")
	fundo.Size = UDim2.new(1, 0, 1, 0)
	fundo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	fundo.BackgroundTransparency = 1
	fundo.BorderSizePixel = 0
	fundo.Parent = splashGui

	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, 300, 0, 120)
	container.Position = UDim2.new(0.5, 0, 0.5, 0)
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.BackgroundTransparency = 1
	container.Parent = splashGui

	local textoBy = Instance.new("TextLabel")
	textoBy.Size = UDim2.new(1, 0, 0, 30)
	textoBy.BackgroundTransparency = 1
	textoBy.Text = "By"
	textoBy.TextColor3 = Color3.fromRGB(200, 200, 200)
	textoBy.TextSize = 22
	textoBy.Font = Enum.Font.Gotham
	textoBy.TextTransparency = 1
	textoBy.Parent = container

	local textoPhantom = Instance.new("TextLabel")
	textoPhantom.Size = UDim2.new(1, 0, 0, 60)
	textoPhantom.Position = UDim2.new(0, 0, 0, 30)
	textoPhantom.BackgroundTransparency = 1
	textoPhantom.Text = "PHANTOM"
	textoPhantom.TextColor3 = CONFIG.CorPhantom
	textoPhantom.TextSize = 40
	textoPhantom.Font = Enum.Font.GothamBlack
	textoPhantom.TextTransparency = 1
	textoPhantom.Parent = container

	local strokePhantom = Instance.new("UIStroke")
	strokePhantom.Color = Color3.fromRGB(200, 150, 255)
	strokePhantom.Thickness = 0
	strokePhantom.Transparency = 1
	strokePhantom.Parent = textoPhantom

	local linha = Instance.new("Frame")
	linha.Size = UDim2.new(0, 0, 0, 2)
	linha.Position = UDim2.new(0.5, 0, 1, -10)
	linha.AnchorPoint = Vector2.new(0.5, 0.5)
	linha.BackgroundColor3 = CONFIG.CorPhantom
	linha.BorderSizePixel = 0
	linha.Parent = container

	TweenService:Create(fundo, TweenInfo.new(0.4), { BackgroundTransparency = 0.3 }):Play()
	task.wait(0.2)
	TweenService:Create(textoBy, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
	task.wait(0.2)
	TweenService:Create(textoPhantom, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		TextTransparency = 0,
		TextSize = 52
	}):Play()
	TweenService:Create(strokePhantom, TweenInfo.new(0.5), { Thickness = 2, Transparency = 0.3 }):Play()
	task.wait(0.2)
	TweenService:Create(linha, TweenInfo.new(0.6, Enum.EasingStyle.Quad), { Size = UDim2.new(0.7, 0, 0, 2) }):Play()

	task.wait(1.5)
	TweenService:Create(textoBy, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
	TweenService:Create(textoPhantom, TweenInfo.new(0.4), { TextTransparency = 1, TextSize = 60 }):Play()
	TweenService:Create(strokePhantom, TweenInfo.new(0.4), { Transparency = 1 }):Play()
	TweenService:Create(linha, TweenInfo.new(0.4), { Size = UDim2.new(0, 0, 0, 2) }):Play()
	TweenService:Create(fundo, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()

	task.wait(0.7)
	splashGui:Destroy()
end

-- ============================================
-- ENVIO DE MENSAGEM
-- ============================================
local function enviarMensagem(texto)
	local sucesso = pcall(function()
		local canais = TextChatService:FindFirstChild("TextChannels")
		if canais then
			local canalGeral = canais:FindFirstChild("RBXGeneral")
			if canalGeral then
				canalGeral:SendAsync(texto)
			end
		end
	end)
	if sucesso then return true end

	local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
	if chatEvents then
		local sayMessageRequest = chatEvents:FindFirstChild("SayMessageRequest")
		if sayMessageRequest then
			sayMessageRequest:FireServer(texto, "All")
			return true
		end
	end
	return false
end

-- ============================================
-- TELA DE MANUTENÇÃO
-- ============================================
local function mostrarManutencao()
	if Estado.PainelManutencao then return end

	local manutencaoGui = Instance.new("ScreenGui")
	manutencaoGui.Name = "PainelManutencao"
	manutencaoGui.ResetOnSpawn = false
	manutencaoGui.IgnoreGuiInset = true
	manutencaoGui.DisplayOrder = 400
	manutencaoGui.Parent = playerGui
	Estado.PainelManutencao = manutencaoGui

	local fundoBloqueio = Instance.new("TextButton")
	fundoBloqueio.Size = UDim2.new(1, 0, 1, 0)
	fundoBloqueio.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	fundoBloqueio.BackgroundTransparency = 0.5
	fundoBloqueio.BorderSizePixel = 0
	fundoBloqueio.Text = ""
	fundoBloqueio.AutoButtonColor = false
	fundoBloqueio.Modal = true
	fundoBloqueio.Parent = manutencaoGui

	local painel = Instance.new("Frame")
	painel.Size = UDim2.new(0, 500, 0, 200)
	painel.Position = UDim2.new(0.5, 0, 0.5, 0)
	painel.AnchorPoint = Vector2.new(0.5, 0.5)
	painel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	painel.BackgroundTransparency = 0.15
	painel.BorderSizePixel = 0
	painel.Parent = manutencaoGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = painel

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(120, 120, 120)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.3
	stroke.Parent = painel

	local titulo = Instance.new("TextLabel")
	titulo.Size = UDim2.new(1, 0, 0, 50)
	titulo.Position = UDim2.new(0, 0, 0, 30)
	titulo.BackgroundTransparency = 1
	titulo.Text = "Painel em manutenção"
	titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
	titulo.TextSize = 28
	titulo.Font = Enum.Font.GothamBold
	titulo.TextTransparency = 1
	titulo.Parent = painel

	local texto1 = Instance.new("TextLabel")
	texto1.Size = UDim2.new(1, -40, 0, 25)
	texto1.Position = UDim2.new(0, 20, 0, 95)
	texto1.BackgroundTransparency = 1
	texto1.Text = "Apenas o hub está funcionando no momento."
	texto1.TextColor3 = Color3.fromRGB(220, 220, 220)
	texto1.TextSize = 16
	texto1.Font = Enum.Font.Gotham
	texto1.TextTransparency = 1
	texto1.Parent = painel

	local texto2 = Instance.new("TextLabel")
	texto2.Size = UDim2.new(1, -40, 0, 25)
	texto2.Position = UDim2.new(0, 20, 0, 130)
	texto2.BackgroundTransparency = 1
	texto2.Text = "Aguarde enquanto o painel passa por manutenção."
	texto2.TextColor3 = Color3.fromRGB(200, 200, 200)
	texto2.TextSize = 16
	texto2.Font = Enum.Font.Gotham
	texto2.TextTransparency = 1
	texto2.Parent = painel

	TweenService:Create(titulo, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
	task.wait(0.15)
	TweenService:Create(texto1, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
	task.wait(0.15)
	TweenService:Create(texto2, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
end

-- ============================================
-- ESCONDER MANUTENÇÃO
-- ============================================
local function esconderManutencao()
	if Estado.PainelManutencao then
		pcall(function()
			Estado.PainelManutencao:Destroy()
		end)
		Estado.PainelManutencao = nil
	end
end

-- ============================================
-- INICIAR HUB
-- ============================================
local function iniciarScript()
	if Estado.Ativo then return end
	Estado.Ativo = true

	esconderManutencao()
	Estado.Conexoes = {}

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BotoesComandos"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 100
	screenGui.Parent = playerGui
	Estado.ScreenGui = screenGui

	local function estilizarBotao(botao, corBorda, raio)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, raio or 10)
		corner.Parent = botao

		local stroke = Instance.new("UIStroke")
		stroke.Color = corBorda
		stroke.Thickness = 2
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = botao

		return stroke
	end

	local function criarBotao(config)
		local botao = Instance.new("TextButton")
		botao.Name = config.nome
		botao.Size = config.tamanho or CONFIG.TamanhoBotao
		botao.Position = config.posicao
		botao.BackgroundColor3 = CONFIG.CorFundo
		botao.BorderSizePixel = 0
		botao.Text = config.emoji
		botao.TextSize = config.tamanhoTexto or 22
		botao.Font = Enum.Font.GothamBold
		botao.TextColor3 = CONFIG.CorTexto
		botao.AutoButtonColor = false
		botao.Active = true
		botao.Parent = screenGui

		local stroke = estilizarBotao(botao, config.corBorda, config.raio)

		local function tween(props, tempo, estilo)
			TweenService:Create(
				botao,
				TweenInfo.new(tempo or CONFIG.TempoAnimacao, estilo or Enum.EasingStyle.Quad),
				props
			):Play()
		end

		local clicando = false
		local function aoClicar()
			if clicando then return end
			clicando = true

			tween({ Size = CONFIG.TamanhoClique }, 0.1, Enum.EasingStyle.Back)
			task.delay(0.1, function()
				tween({ Size = config.tamanho or CONFIG.TamanhoBotao }, 0.15, Enum.EasingStyle.Back)
			end)

			if config.onClick then
				config.onClick()
			elseif config.comando then
				enviarMensagem(config.comando)
			end

			task.wait(0.1)
			clicando = false
		end

		table.insert(Estado.Conexoes, botao.MouseButton1Click:Connect(aoClicar))
		table.insert(Estado.Conexoes, botao.TouchTap:Connect(aoClicar))
		table.insert(Estado.Conexoes, botao.MouseButton1Down:Connect(function()
			tween({ BackgroundColor3 = CONFIG.CorFundoClique }, 0.08)
		end))
		table.insert(Estado.Conexoes, botao.MouseButton1Up:Connect(function()
			tween({ BackgroundColor3 = CONFIG.CorFundoHover }, 0.12)
		end))
		table.insert(Estado.Conexoes, botao.MouseEnter:Connect(function()
			tween({ Size = CONFIG.TamanhoHover, BackgroundColor3 = CONFIG.CorFundoHover }, 0.15)
		end))
		table.insert(Estado.Conexoes, botao.MouseLeave:Connect(function()
			tween({ Size = config.tamanho or CONFIG.TamanhoBotao, BackgroundColor3 = CONFIG.CorFundo }, 0.15)
		end))

		return botao, stroke
	end

	-- ==========================================
	-- BOTÕES PRINCIPAIS
	-- ==========================================
	local botaoRender = criarBotao({
		nome = "BotaoRender", emoji = "😶",
		posicao = UDim2.new(0, 15, 0.5, -160),
		comando = "//render",
		corBorda = Color3.fromRGB(255, 215, 0),
	})

	local botaoMat = criarBotao({
		nome = "BotaoMat", emoji = "☠️",
		posicao = UDim2.new(0, 15, 0.5, -110),
		comando = ".Mira 🎯:: Cabeça `` Disparo (MAT) — {DEITA}",
		corBorda = Color3.fromRGB(150, 100, 255),
	})

	local botaoPneu = criarBotao({
		nome = "BotaoPneu", emoji = "🎯",
		posicao = UDim2.new(0, 15, 0.5, -60),
		comando = "./atira no Pneu",
		corBorda = Color3.fromRGB(255, 100, 100),
	})

	local botaoPeaky = criarBotao({
		nome = "BotaoPeaky", emoji = "👑",
		posicao = UDim2.new(0, 15, 0.5, -10),
		comando = "Finalizar — Peaky Blinders! 👑",
		corBorda = Color3.fromRGB(200, 200, 200),
	})

	-- ==========================================
	-- TOGGLE
	-- ==========================================
	local botoesVisiveis = true
	local function atualizarVisibilidade()
		botaoRender.Visible = botoesVisiveis
		botaoMat.Visible = botoesVisiveis
		botaoPneu.Visible = botoesVisiveis
		botaoPeaky.Visible = botoesVisiveis
	end

	local botaoToggle, strokeToggle = criarBotao({
		nome = "BotaoToggle", emoji = "👁️",
		posicao = UDim2.new(0, 19, 0.5, -200),
		corBorda = Color3.fromRGB(200, 200, 200),
		tamanho = UDim2.new(0, 34, 0, 34),
		tamanhoTexto = 16, raio = 8,
	})

	local function alternarToggle()
		botoesVisiveis = not botoesVisiveis
		atualizarVisibilidade()
		if botoesVisiveis then
			botaoToggle.Text = "👁️"
			strokeToggle.Color = Color3.fromRGB(200, 200, 200)
		else
			botaoToggle.Text = "🚫"
			strokeToggle.Color = Color3.fromRGB(255, 80, 80)
		end
	end

	table.insert(Estado.Conexoes, botaoToggle.MouseButton1Click:Connect(alternarToggle))
	table.insert(Estado.Conexoes, botaoToggle.TouchTap:Connect(alternarToggle))

	print("✅ [Phantom] HUB INICIADO")
end

-- ============================================
-- PARAR HUB
-- ============================================
local function pararScript()
	if not Estado.Ativo then return end
	Estado.Ativo = false

	for _, conexao in ipairs(Estado.Conexoes) do
		pcall(function() conexao:Disconnect() end)
	end
	Estado.Conexoes = {}

	if Estado.ScreenGui then
		pcall(function() Estado.ScreenGui:Destroy() end)
		Estado.ScreenGui = nil
	end

	for _, gui in ipairs(playerGui:GetChildren()) do
		if gui.Name == "BotoesComandos" then
			pcall(function() gui:Destroy() end)
		end
	end

	mostrarManutencao()
	print("⛔ [Phantom] HUB PARADO")
end

-- ============================================
-- PAINEL DO DONO
-- ============================================
local function criarPainelDono()
	local painelGui = Instance.new("ScreenGui")
	painelGui.Name = "PainelDonoPhantom"
	painelGui.ResetOnSpawn = false
	painelGui.IgnoreGuiInset = true
	painelGui.DisplayOrder = 500
	painelGui.Parent = playerGui

	local painel = Instance.new("Frame")
	painel.Name = "Painel"
	painel.Size = UDim2.new(0, 200, 0, 230)
	painel.Position = UDim2.new(0.5, -100, 0.3, 0)
	painel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	painel.BorderSizePixel = 0
	painel.Parent = painelGui

	local cornerPainel = Instance.new("UICorner")
	cornerPainel.CornerRadius = UDim.new(0, 12)
	cornerPainel.Parent = painel

	local strokePainel = Instance.new("UIStroke")
	strokePainel.Color = CONFIG.CorPhantom
	strokePainel.Thickness = 2
	strokePainel.Parent = painel

	local titulo = Instance.new("TextLabel")
	titulo.Size = UDim2.new(1, 0, 0, 32)
	titulo.BackgroundTransparency = 1
	titulo.Text = "👑 PAINEL DO DONO"
	titulo.TextColor3 = CONFIG.CorPhantom
	titulo.TextSize = 14
	titulo.Font = Enum.Font.GothamBold
	titulo.Parent = painel

	local status = Instance.new("TextLabel")
	status.Name = "Status"
	status.Size = UDim2.new(1, 0, 0, 22)
	status.Position = UDim2.new(0, 0, 0, 34)
	status.BackgroundTransparency = 1
	status.Text = "● HUB ATIVO"
	status.TextColor3 = Color3.fromRGB(80, 255, 100)
	status.TextSize = 12
	status.Font = Enum.Font.GothamBold
	status.Parent = painel

	local function criarBotaoPainel(texto, cor, posY, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.85, 0, 0, 32)
		btn.Position = UDim2.new(0.075, 0, 0, posY)
		btn.BackgroundColor3 = cor
		btn.BorderSizePixel = 0
		btn.Text = texto
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 14
		btn.Font = Enum.Font.GothamBold
		btn.AutoButtonColor = false
		btn.Parent = painel

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = btn

		btn.MouseButton1Click:Connect(function() pcall(callback) end)
		btn.TouchTap:Connect(function() pcall(callback) end)

		return btn
	end

	local function atualizarStatus()
		if Estado.Ativo then
			status.Text = "● HUB ATIVO"
			status.TextColor3 = Color3.fromRGB(80, 255, 100)
		else
			status.Text = "● HUB PARADO"
			status.TextColor3 = Color3.fromRGB(255, 80, 80)
		end
	end

	criarBotaoPainel("▶️  EXECUTAR HUB", Color3.fromRGB(40, 130, 60), 65, function()
		iniciarScript()
		atualizarStatus()
	end)

	criarBotaoPainel("⏹️  PARAR HUB", Color3.fromRGB(170, 40, 40), 105, function()
		pararScript()
		atualizarStatus()
	end)

	criarBotaoPainel("🔄  REINICIAR", Color3.fromRGB(200, 140, 30), 145, function()
		pararScript()
		task.wait(0.2)
		iniciarScript()
		atualizarStatus()
	end)

	local btnFechar
	btnFechar = criarBotaoPainel("🚪  FECHAR PAINEL", Color3.fromRGB(70, 70, 70), 185, function()
		painelGui.Enabled = false
	end)

	local btnAbrir = Instance.new("TextButton")
	btnAbrir.Size = UDim2.new(0, 40, 0, 40)
	btnAbrir.Position = UDim2.new(0, 15, 0, 15)
	btnAbrir.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btnAbrir.BorderSizePixel = 0
	btnAbrir.Text = "👑"
	btnAbrir.TextSize = 20
	btnAbrir.Font = Enum.Font.GothamBold
	btnAbrir.TextColor3 = CONFIG.CorPhantom
	btnAbrir.AutoButtonColor = false
	btnAbrir.Visible = false
	btnAbrir.Parent = painelGui

	local cornerAbrir = Instance.new("UICorner")
	cornerAbrir.CornerRadius = UDim.new(0, 10)
	cornerAbrir.Parent = btnAbrir

	local strokeAbrir = Instance.new("UIStroke")
	strokeAbrir.Color = CONFIG.CorPhantom
	strokeAbrir.Thickness = 2
	strokeAbrir.Parent = btnAbrir

	btnFechar.MouseButton1Click:Connect(function()
		painel.Visible = false
		btnAbrir.Visible = true
	end)

	btnAbrir.MouseButton1Click:Connect(function()
		painel.Visible = true
		btnAbrir.Visible = false
	end)

	print("✅ [Phantom] Painel do Dono carregado")
end

-- ============================================
-- EXECUÇÃO INICIAL
-- ============================================
task.spawn(mostrarAbertura)
criarPainelDono()
iniciarScript()

print("✅ [Phantom] Tudo carregado!")
