-- LocalScript (coloque em StarterPlayerScripts ou StarterCharacterScripts)

-- Espera o personagem carregar
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Tempo entre pulos (em segundos)
local intervaloDePulo = 1.5

-- Função para pular
local function pularAutomaticamente()
	while true do
		wait(intervaloDePulo)
		if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end

-- Inicia o loop de pulo automático
pularAutomaticamente()
