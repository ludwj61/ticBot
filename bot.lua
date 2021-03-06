local discordia = require("discordia")
local jsonReader = require("./jsonReader")

local Board = require("./board.lua")
local utils = require("./utils.lua")

local client = discordia.Client()
local TOKEN = jsonReader.ReadToken()

local gameBoard = Board.new()

client:on("ready", function() print("Logged in as " .. client.user.username) end)

client:on("messageCreate", function(message)
    local content = utils.SplitMessage(message.content)

    if content[1] == "%test" then gameBoard:TestPrint() end

    if content[1] == "%clear" then
        gameBoard = Board.new()
        message.channel:send(gameBoard:Prettify())
    end

    if content[1] == "%play" or content[1] == "%p" then
        if not gameBoard:TakeTurn(content[2], content[3]) then
            message.channel:send(gameBoard.ShowError())
        else
            message.channel:send(gameBoard:Prettify())

            local endCheck = gameBoard:CheckWinner()
            if endCheck == "X" then
                message.channel:send(gameBoard.ShowWin("X"))
            elseif endCheck == "O" then
                message.channel:send(gameBoard.ShowWin("O"))
            elseif endCheck == "Tied" then
                message.channel:send(gameBoard.ShowTie())
            end
        end
    end
end)

client:run("Bot " .. TOKEN)
