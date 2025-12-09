-- Last Letter Word Helper V4 - AI Enhanced
-- Rayfield UI Version
-- By Assistant

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local TeleportService = game:GetService("TeleportService")

-- Player
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()

-- Variables
local AutoFollow = false
local AutoType = false
local AutoAnswer = false
local AutoClick = false
local UseAI = false
local WordList = {}
local LastLetter = ""
local CurrentWord = ""
local GameWord = ""
local Connection
local WordHistory = {}
local MaxHistory = 50

-- API Configuration
local OpenAIConfig = {
    APIKey = "",
    BaseURL = "https://api.openai.com/v1/chat/completions",
    Model = "gpt-3.5-turbo"
}

local FreeAIConfig = {
    APIKey = "",
    BaseURL = "https://api.openai.com/v1/chat/completions", -- Ganti dengan API gratis jika ada
    Model = "gpt-3.5-turbo"
}

-- Main Window
local Window = Rayfield:CreateWindow({
    Name = "🅻🅰🆂🆃 🅻🅴🆃🆃🅴🆁 🆆🅾🆁🅳 🅷🅴🅻🅿🅴🆁 V4",
    LoadingTitle = "Loading AI-Powered Helper...",
    LoadingSubtitle = "by Assistant • GPT-3.5 Enhanced",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LastLetterHelperAI",
        FileName = "AIConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Main Tab
local MainTab = Window:CreateTab("🤖 Main Features", 4483362458)

-- Auto Answer Toggle
local AutoAnswerToggle = MainTab:CreateToggle({
    Name = "🚀 Auto Answer (AI Enhanced)",
    CurrentValue = false,
    Flag = "AutoAnswerToggle",
    Callback = function(Value)
        AutoAnswer = Value
        if AutoAnswer then
            startAutoAnswer()
            Rayfield:Notify({
                Title = "AI Assistant Activated",
                Content = "AI will now automatically find matching words",
                Duration = 3,
                Image = 4483362458,
            })
        else
            stopAutoAnswer()
        end
    end,
})

-- Auto Type Toggle
local AutoTypeToggle = MainTab:CreateToggle({
    Name = "⌨️ Auto Type Words",
    CurrentValue = false,
    Flag = "AutoTypeToggle",
    Callback = function(Value)
        AutoType = Value
        if AutoType then
            startAutoType()
        else
            stopAutoType()
        end
    end,
})

-- AI Mode Toggle
local AIModeToggle = MainTab:CreateToggle({
    Name = "🧠 Use AI for Word Generation",
    CurrentValue = false,
    Flag = "AIModeToggle",
    Callback = function(Value)
        UseAI = Value
        Rayfield:Notify({
            Title = Value and "AI Mode Enabled" or "AI Mode Disabled",
            Content = Value and "Using GPT-3.5 for word generation" or "Using local dictionary",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Auto Click Toggle
local AutoClickToggle = MainTab:CreateToggle({
    Name = "🖱️ Auto Click Submit",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(Value)
        AutoClick = Value
        if AutoClick then
            spawn(function()
                while AutoClick and wait(1) do
                    clickSubmitButton()
                end
            end)
        end
    end,
})

-- Word Detection Display
local WordDisplayLabel = MainTab:CreateLabel("📝 Current Word: Waiting for game...")
local LastLetterLabel = MainTab:CreateLabel("🔤 Last Letter: -")
local SuggestedWordLabel = MainTab:CreateLabel("💡 Suggested Word: -")

-- Word Input Section
local WordInput = MainTab:CreateInput({
    Name = "➕ Add Custom Word",
    PlaceholderText = "Enter word here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text ~= "" and #Text > 1 then
            local word = string.lower(string.gsub(Text, "%s+", ""))
            if not table.find(WordList, word) then
                table.insert(WordList, word)
                Rayfield:Notify({
                    Title = "✅ Word Added",
                    Content = "Added: " .. word,
                    Duration = 2,
                    Image = 4483362458,
                })
                updateWordListDisplay()
            end
        end
    end,
})

-- Quick Add Buttons
MainTab:CreateSection("Quick Actions")

MainTab:CreateButton({
    Name = "📥 Get Current Word from Screen",
    Callback = function()
        detectCurrentWord()
    end,
})

MainTab:CreateButton({
    Name = "✨ Generate AI Suggestion",
    Callback = function()
        if LastLetter ~= "" then
            generateAISuggestion(LastLetter)
        else
            Rayfield:Notify({
                Title = "⚠️ No Last Letter",
                Content = "Detect a word first!",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

MainTab:CreateButton({
    Name = "⚡ Type Suggested Word",
    Callback = function()
        local word = SuggestedWordLabel.Text:match("💡 Suggested Word: (.+)")
        if word and word ~= "-" then
            typeWord(word)
            Rayfield:Notify({
                Title = "⌨️ Typing Word",
                Content = "Typing: " .. word,
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

-- API Configuration Section
SettingsTab:CreateSection("🤖 AI API Configuration")

local APIKeyInput = SettingsTab:CreateInput({
    Name = "OpenAI API Key (Optional)",
    PlaceholderText = "sk-...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        OpenAIConfig.APIKey = Text
        Rayfield:Notify({
            Title = "🔑 API Key Saved",
            Content = "API key has been stored locally",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

SettingsTab:CreateDropdown({
    Name = "AI Model",
    Options = {"gpt-3.5-turbo", "gpt-4", "gpt-4-turbo"},
    CurrentOption = "gpt-3.5-turbo",
    Flag = "AIModel",
    Callback = function(Option)
        OpenAIConfig.Model = Option
    end,
})

-- Word Detection Settings
SettingsTab:CreateSection("🔍 Word Detection Settings")

local ScanDelaySlider = SettingsTab:CreateSlider({
    Name = "Scan Delay (seconds)",
    Range = {0.1, 3},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Flag = "ScanDelay",
    Callback = function(Value)
        ScanDelay = Value
    end,
})

SettingsTab:CreateToggle({
    Name = "Scan All GUI Elements",
    CurrentValue = true,
    Flag = "DeepScan",
    Callback = function(Value)
        DeepScan = Value
    end,
})

-- Word Management Section
SettingsTab:CreateSection("📚 Word Management")

SettingsTab:CreateButton({
    Name = "🗑️ Clear Custom Words",
    Callback = function()
        WordList = {}
        Rayfield:Notify({
            Title = "🗑️ Words Cleared",
            Content = "All custom words removed",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

SettingsTab:CreateButton({
    Name = "📥 Load English Dictionary",
    Callback = function()
        loadEnglishDictionary()
    end,
})

SettingsTab:CreateButton({
    Name = "💾 Export Word List",
    Callback = function()
        exportWordList()
    end,
})

SettingsTab:CreateButton({
    Name = "📤 Import Word List",
    Callback = function()
        importWordList()
    end,
})

-- Word List Display
local WordListSection = SettingsTab:CreateSection("📋 Custom Word List")
local WordListLabel = SettingsTab:CreateLabel("Total Words: 0")
local WordListPreview = SettingsTab:CreateParagraph({
    Title = "Recent Words",
    Content = "No words added yet"
})

-- AI Tab
local AITab = Window:CreateTab("🧠 AI Assistant", 4483362458)

AITab:CreateSection("AI Word Generator")

local AIPromptInput = AITab:CreateInput({
    Name = "Custom AI Prompt",
    PlaceholderText = "Give me a word starting with 'A' related to animals...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        AIPrompt = Text
    end,
})

AITab:CreateButton({
    Name = "🎲 Generate Random Word by Letter",
    Callback = function()
        local letters = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
        local randomLetter = letters[math.random(1, #letters)]
        generateAISuggestion(randomLetter)
    end,
})

-- AI Response Display
AITab:CreateSection("AI Response")
local AIResponseLabel = AITab:CreateLabel("🤖 AI: Ready to generate words...")

-- History Tab
local HistoryTab = Window:CreateTab("📜 History", 4483362458)

HistoryTab:CreateSection("Game History")

local HistoryDisplay = HistoryTab:CreateParagraph({
    Title = "Recent Words History",
    Content = "No history yet"
})

HistoryTab:CreateButton({
    Name = "🔄 Refresh History",
    Callback = function()
        updateHistoryDisplay()
    end,
})

HistoryTab:CreateButton({
    Name = "🗑️ Clear History",
    Callback = function()
        WordHistory = {}
        updateHistoryDisplay()
        Rayfield:Notify({
            Title = "🗑️ History Cleared",
            Content = "All history removed",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Functions
function detectCurrentWord()
    local foundWord = nil
    local gui = player.PlayerGui
    
    -- Cari di semua ScreenGui
    for _, screenGui in pairs(gui:GetChildren()) do
        if screenGui:IsA("ScreenGui") and screenGui.Enabled then
            -- Cari TextLabel dengan kata yang panjang
            for _, obj in pairs(screenGui:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    local text = string.gsub(obj.Text, "%s+", " ")
                    text = string.match(text, "[%a%s]+")
                    
                    if text and #text >= 2 and #text <= 15 then
                        -- Filter untuk menghindari UI text biasa
                        local isUIName = false
                        local uiNames = {"submit", "start", "play", "exit", "menu", "settings", "back", "next"}
                        
                        for _, uiName in pairs(uiNames) do
                            if string.lower(text) == uiName then
                                isUIName = true
                                break
                            end
                        end
                        
                        if not isUIName and not string.find(text, "%d") then
                            -- Cek jika text ada di dictionary atau berupa kata valid
                            local success, result = pcall(function()
                                return TextService:FilterStringAsync(text, player.UserId)
                            end)
                            
                            if success then
                                foundWord = string.lower(text)
                                break
                            end
                        end
                    end
                end
            end
        end
        if foundWord then break end
    end
    
    -- Jika tidak ketemu, coba cari di TextBox
    if not foundWord then
        for _, screenGui in pairs(gui:GetChildren()) do
            if screenGui:IsA("ScreenGui") then
                for _, obj in pairs(screenGui:GetDescendants()) do
                    if obj:IsA("TextBox") and obj.Visible then
                        local text = obj.Text
                        if text and #text >= 2 then
                            foundWord = string.lower(text)
                            break
                        end
                    end
                end
            end
            if foundWord then break end
        end
    end
    
    if foundWord then
        GameWord = foundWord
        LastLetter = getLastLetter(foundWord)
        
        WordDisplayLabel:Set("📝 Current Word: " .. foundWord)
        LastLetterLabel:Set("🔤 Last Letter: " .. (LastLetter or "-"))
        
        -- Tambah ke history
        table.insert(WordHistory, 1, {
            word = foundWord,
            lastLetter = LastLetter,
            time = os.date("%H:%M:%S")
        })
        
        if #WordHistory > MaxHistory then
            table.remove(WordHistory, MaxHistory + 1)
        end
        
        -- Generate suggestion
        if AutoAnswer then
            generateSuggestion(LastLetter)
        end
        
        updateHistoryDisplay()
        
        return foundWord
    end
    
    return nil
end

function getLastLetter(word)
    if not word or #word == 0 then return "" end
    
    -- Bersihkan word dari spasi
    word = string.gsub(word, "%s+", "")
    
    -- Ambil huruf terakhir
    local lastChar = string.sub(word, -1)
    
    -- Handle special cases (kata berakhiran non-alphabet)
    if not string.match(lastChar, "%a") then
        if #word > 1 then
            lastChar = string.sub(word, -2, -2)
        end
    end
    
    return string.lower(lastChar)
end

function generateSuggestion(lastLetter)
    if not lastLetter or lastLetter == "" then return nil end
    
    local suggestion = nil
    
    if UseAI and OpenAIConfig.APIKey and OpenAIConfig.APIKey ~= "" then
        -- Gunakan AI
        suggestion = generateWordWithAI(lastLetter)
    else
        -- Gunakan local dictionary
        suggestion = findMatchingWord(lastLetter)
    end
    
    if suggestion then
        SuggestedWordLabel:Set("💡 Suggested Word: " .. suggestion)
        AIResponseLabel:Set("🤖 AI: Suggested '" .. suggestion .. "' for letter '" .. lastLetter .. "'")
    end
    
    return suggestion
end

function generateWordWithAI(lastLetter)
    local prompt = AIPrompt or "Give me one common English word starting with the letter '" .. lastLetter .. "'. Only return the word, nothing else."
    
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = OpenAIConfig.BaseURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. OpenAIConfig.APIKey
            },
            Body = HttpService:JSONEncode({
                model = OpenAIConfig.Model,
                messages = {
                    {
                        role = "system",
                        content = "You are a helpful assistant that provides valid English words for a last-letter word game."
                    },
                    {
                        role = "user",
                        content = prompt
                    }
                },
                max_tokens = 20,
                temperature = 0.7
            })
        })
    end)
    
    if success then
        local data = HttpService:JSONDecode(response.Body)
        if data.choices and #data.choices > 0 then
            local word = data.choices[1].message.content
            -- Bersihkan response (kadang AI kasih penjelasan)
            word = string.match(word, "[%a]+") or word
            word = string.gsub(word, "%s+", "")
            word = string.lower(word)
            
            if #word >= 2 then
                -- Simpan ke word list
                if not table.find(WordList, word) then
                    table.insert(WordList, word)
                    updateWordListDisplay()
                end
                return word
            end
        end
    end
    
    -- Fallback ke local dictionary jika AI gagal
    return findMatchingWord(lastLetter)
end

function findMatchingWord(lastLetter)
    -- Prioritize custom words
    for _, word in pairs(WordList) do
        if string.sub(string.lower(word), 1, 1) == lastLetter then
            return word
        end
    end
    
    -- Common English words sebagai fallback
    local commonWords = {
        a = {"apple", "ant", "air", "art", "arm", "ask", "age", "ago", "aim"},
        b = {"ball", "bat", "bed", "bee", "boy", "bus", "box", "bag", "big"},
        c = {"cat", "car", "cup", "can", "cap", "cow", "cry", "cut", "cake"},
        d = {"dog", "day", "dad", "dot", "duck", "door", "dark", "deep", "dirt"},
        e = {"egg", "eye", "ear", "end", "eat", "elf", "era", "east", "easy"},
        f = {"fox", "fan", "fun", "fly", "fish", "food", "fire", "five", "four"},
        g = {"goat", "girl", "game", "gold", "good", "gift", "golf", "gate", "gear"},
        h = {"hat", "hen", "hot", "hand", "head", "home", "hope", "huge", "hike"},
        i = {"ice", "ink", "inn", "idea", "iron", "item", "icon", "inch", "idle"},
        j = {"jam", "jar", "jet", "jump", "joke", "jazz", "jack", "jail", "jade"},
        k = {"key", "kid", "king", "kite", "kiss", "kind", "keep", "keen", "knee"},
        l = {"lion", "leg", "lip", "lake", "love", "light", "long", "last", "live"},
        m = {"monkey", "man", "mat", "moon", "milk", "mouse", "music", "make", "more"},
        n = {"nest", "net", "nose", "name", "night", "nice", "nine", "need", "near"},
        o = {"owl", "ox", "orange", "open", "over", "only", "once", "oval", "oak"},
        p = {"pig", "pen", "pot", "play", "park", "pink", "push", "pull", "pure"},
        q = {"queen", "quick", "quiet", "quilt", "quest", "quote", "quark", "quake"},
        r = {"rat", "rug", "rain", "rose", "ring", "road", "read", "rock", "real"},
        s = {"sun", "star", "shoe", "ship", "sand", "song", "slow", "soft", "safe"},
        t = {"tiger", "tree", "table", "train", "time", "talk", "true", "tail", "tall"},
        u = {"umbrella", "under", "up", "use", "unit", "user", "ugly", "upon", "undo"},
        v = {"van", "vet", "vase", "very", "vote", "view", "void", "vain", "verb"},
        w = {"wolf", "window", "water", "wind", "walk", "warm", "wise", "work", "wait"},
        x = {"xray", "xenon", "xylem", "xebec", "xeric", "xerus", "xenia", "xylan"},
        y = {"yak", "yarn", "year", "yellow", "young", "yoga", "yard", "yell", "yoke"},
        z = {"zebra", "zoo", "zero", "zone", "zest", "zoom", "zinc", "zany", "zeal"}
    }
    
    if commonWords[lastLetter] then
        return commonWords[lastLetter][math.random(1, #commonWords[lastLetter])]
    end
    
    return nil
end

function typeWord(word)
    if not word then return end
    
    -- Cari text box aktif
    local textBox = findTextBox()
    if textBox then
        -- Focus ke text box
        textBox:CaptureFocus()
        wait(0.1)
        
        -- Clear existing text
        textBox.Text = ""
        wait(0.1)
        
        -- Type karakter per karakter
        for i = 1, #word do
            local char = string.sub(word, i, i)
            VirtualInputManager:SendKeyEvent(true, char, false, game)
            wait(0.03)
            VirtualInputManager:SendKeyEvent(false, char, false, game)
            wait(0.01)
        end
        
        return true
    end
    
    return false
end

function findTextBox()
    local gui = player.PlayerGui
    for _, screenGui in pairs(gui:GetChildren()) do
        if screenGui:IsA("ScreenGui") then
            for _, obj in pairs(screenGui:GetDescendants()) do
                if obj:IsA("TextBox") and obj.Visible and obj.Active then
                    return obj
                end
            end
        end
    end
    return nil
end

function clickSubmitButton()
    local gui = player.PlayerGui
    for _, screenGui in pairs(gui:GetChildren()) do
        if screenGui:IsA("ScreenGui") then
            for _, obj in pairs(screenGui:GetDescendants()) do
                if obj:IsA("TextButton") and obj.Visible then
                    local text = string.lower(obj.Text or "")
                    local name = string.lower(obj.Name or "")
                    
                    if string.find(text, "submit") or string.find(text, "enter") or 
                       string.find(text, "send") or string.find(name, "submit") then
                        
                        -- Click button
                        if obj:FindFirstChildWhichIsA("ClickDetector") then
                            fireclickdetector(obj:FindFirstChildWhichIsA("ClickDetector"))
                        else
                            -- Simulate click
                            pcall(function()
                                obj:Fire("MouseButton1Click")
                                obj:Fire("Activated")
                            end)
                        end
                        return true
                    end
                end
            end
        end
    end
    return false
end

function startAutoAnswer()
    spawn(function()
        while AutoAnswer do
            local word = detectCurrentWord()
            if word and LastLetter ~= "" then
                local suggestion = generateSuggestion(LastLetter)
                if suggestion then
                    wait(ScanDelay or 0.5)
                    
                    -- Type the word
                    if typeWord(suggestion) then
                        wait(0.2)
                        
                        -- Auto click submit jika diaktifkan
                        if AutoClick then
                            clickSubmitButton()
                        end
                        
                        -- Update UI
                        Rayfield:Notify({
                            Title = "✅ Auto Answer",
                            Content = "Typed: " .. suggestion,
                            Duration = 2,
                            Image = 4483362458,
                        })
                    end
                end
            end
            wait(ScanDelay or 0.5)
        end
    end)
end

function stopAutoAnswer()
    -- Nothing specific needed
end

function startAutoType()
    spawn(function()
        while AutoType do
            detectCurrentWord()
            wait(ScanDelay or 0.5)
        end
    end)
end

function stopAutoType()
    -- Nothing specific needed
end

function loadEnglishDictionary()
    local commonWords = {
        "ability", "absence", "academy", "account", "achievement", "acoustic", "action", "activity", 
        "adventure", "aesthetic", "afternoon", "agreement", "airport", "alcohol", "alligator", "amazing",
        "ambition", "analysis", "ancient", "angel", "animal", "anniversary", "answer", "antelope",
        "apartment", "apology", "apparatus", "appearance", "apple", "application", "appointment",
        "architect", "argument", "arrival", "article", "artist", "assignment", "assistant", "athlete",
        "attention", "attitude", "audience", "authority", "autumn", "average", "avocado", "awareness",
        "backbone", "balance", "balloon", "banana", "barbecue", "baseball", "basket", "bathroom",
        "battery", "beautiful", "bedroom", "beginning", "behavior", "belief", "bicycle", "biscuit",
        "blanket", "blessing", "blossom", "blueberry", "bookshelf", "bouquet", "breeze", "broccoli",
        "brother", "building", "butterfly", "cabinet", "calendar", "camera", "campaign", "candidate",
        "carpenter", "carrot", "castle", "catalog", "cathedral", "celebration", "challenge", "champion",
        "character", "charming", "cheetah", "chemical", "children", "chocolate", "cinnamon", "circus",
        "citizen", "classic", "climate", "clothing", "coconut", "coffee", "collection", "college",
        "comfort", "commercial", "community", "company", "comparison", "competition", "computer",
        "concept", "concert", "condition", "confidence", "connection", "conscious", "constant",
        "construction", "consumer", "container", "content", "contest", "context", "contract",
        "contrast", "contribution", "control", "conversation", "cooking", "copper", "corner",
        "corporation", "costume", "cottage", "council", "counsel", "country", "couple", "courage",
        "courtesy", "coverage", "cowboy", "creation", "creative", "creature", "cricket", "criminal",
        "crisis", "criticism", "crocodile", "cucumber", "culture", "curiosity", "curtain", "customer",
        "dancing", "darkness", "database", "daughter", "daylight", "decision", "decorate", "delicate",
        "delicious", "delivery", "democracy", "department", "departure", "dependent", "designer",
        "desktop", "dessert", "destination", "detail", "detective", "development", "device", "diamond",
        "dictionary", "difference", "difficult", "digital", "dinosaur", "direction", "disaster",
        "discipline", "discovery", "discussion", "disease", "display", "distance", "distribution",
        "dolphin", "domestic", "donation", "doorbell", "drawing", "dressing", "driver", "drought",
        "drummer", "duckling", "duration", "dwelling", "dynamic", "eagle", "earring", "earthquake",
        "economics", "education", "effective", "efficiency", "effort", "elderly", "election",
        "electric", "elephant", "elevator", "emergency", "emotion", "emperor", "employee", "enchanted",
        "ending", "endless", "endorse", "enemy", "energy", "engine", "enjoyment", "enormous",
        "entertain", "entire", "entrance", "envelope", "environment", "episode", "equation",
        "equipment", "eraser", "erosion", "escape", "essence", "estate", "estimate", "eternal",
        "evening", "evidence", "evolution", "exactly", "example", "excellent", "exchange", "excited",
        "exciting", "exercise", "exhibit", "existence", "expense", "experience", "experiment",
        "expert", "explain", "explore", "express", "extend", "extreme", "fabric", "facility",
        "factory", "faculty", "failure", "fairness", "family", "famous", "fantasy", "farmer",
        "fashion", "father", "feature", "federal", "feeling", "fiction", "field", "fighter",
        "figure", "filament", "filing", "filter", "final", "finance", "finger", "firefly",
        "fisherman", "fitness", "flamingo", "flavor", "flight", "floating", "flood", "floor",
        "flower", "focus", "foggy", "follower", "following", "food", "football", "force",
        "forecast", "foreign", "forest", "forever", "forget", "formal", "formation", "former",
        "formula", "fortune", "forward", "foundation", "fountain", "fraction", "fragment",
        "freedom", "frequency", "friend", "frog", "frontier", "frosting", "fruit", "fuel",
        "function", "funding", "funeral", "funny", "furniture", "future", "gallery", "garden",
        "garlic", "gasoline", "gateway", "general", "generation", "genius", "gentle", "geography",
        "gesture", "ghost", "giraffe", "girlfriend", "giveaway", "glacier", "glasses", "global",
        "glorious", "glossary", "gloves", "golden", "goodbye", "gorgeous", "government", "graceful",
        "graduate", "graffiti", "grandfather", "grandmother", "grape", "graphic", "grass", "grateful",
        "gravity", "greeting", "grocery", "ground", "growing", "growth", "guarantee", "guardian",
        "guest", "guidance", "guide", "guitar", "habitat", "haircut", "halfway", "hallway",
        "hamburger", "hammer", "handbag", "handmade", "happiness", "harmony", "harvest", "headline",
        "headphones", "health", "hearing", "heartbeat", "heaven", "heavy", "helicopter", "helmet",
        "helpful", "heritage", "highlight", "highway", "hiking", "history", "hockey", "holiday",
        "hollow", "hometown", "honest", "honey", "honor", "horizon", "horse", "hospital",
        "hospitality", "hotel", "household", "human", "humor", "hunter", "hurricane", "husband",
        "hyena", "hygiene", "hypothesis", "iceberg", "icecream", "idea", "identity", "ignorant",
        "illusion", "illustration", "image", "imagination", "impact", "implement", "importance",
        "impression", "improve", "incident", "income", "increase", "independence", "index",
        "indicate", "individual", "industry", "infant", "infection", "infinite", "influence",
        "information", "ingredient", "initial", "injury", "innovation", "input", "inquiry",
        "insect", "inside", "inspiration", "instance", "instruction", "instrument", "insurance",
        "integer", "intellect", "intelligence", "intention", "interaction", "interest", "interior",
        "internal", "international", "internet", "interview", "introduction", "invasion", "invention",
        "investment", "invitation", "island", "item", "jacket", "jaguar", "jellyfish", "jewelry",
        "journal", "journey", "judgment", "juice", "jungle", "junior", "justice", "kangaroo",
        "kingdom", "kitchen", "kitten", "knowledge", "laboratory", "landscape", "language",
        "laughter", "lawyer", "leadership", "learning", "leather", "lecture", "legacy", "legal",
        "legend", "leisure", "lemon", "leopard", "lesson", "letter", "liberty", "library",
        "license", "life", "lighthouse", "lightning", "limit", "line", "lion", "literature",
        "lizard", "location", "logical", "lonely", "lottery", "lounge", "loyalty", "luck",
        "luggage", "lumber", "lunch", "luxury", "machine", "magazine", "magic", "magnificent",
        "mailbox", "maintenance", "major", "makeup", "management", "mango", "manner", "manual",
        "manufacture", "many", "maple", "marathon", "marble", "margarine", "market", "marriage",
        "master", "material", "mathematics", "matter", "maximum", "meadow", "meaning", "measurement",
        "meat", "mechanic", "media", "medicine", "meeting", "melody", "member", "memory",
        "mentor", "menu", "merchant", "message", "metal", "method", "midnight", "migration",
        "military", "million", "mineral", "minister", "miracle", "mirror", "mission", "mistake",
        "mixture", "mobile", "model", "modern", "modification", "moment", "monitor", "monkey",
        "monster", "month", "morning", "mortgage", "mother", "motion", "motivation", "motor",
        "mountain", "mouse", "movement", "multiple", "museum", "music", "mustard", "mystery",
        "myth", "nail", "name", "napkin", "narrative", "nation", "natural", "nature", "navigation",
        "necessary", "necklace", "negative", "negotiation", "neighbor", "nephew", "nerve", "nest",
        "network", "news", "newspaper", "nightmare", "nitrogen", "nobody", "noise", "normal",
        "north", "notebook", "nothing", "notice", "novel", "november", "number", "nurse",
        "nutrient", "oak", "object", "obligation", "observation", "occasion", "occupation",
        "ocean", "october", "offer", "office", "official", "oil", "olive", "omega", "onion",
        "online", "opening", "opera", "operation", "opinion", "opportunity", "opposite", "option",
        "orange", "orbit", "orchard", "order", "ordinary", "organization", "original", "other",
        "otter", "outcome", "outdoor", "outfit", "outlet", "output", "outside", "oval", "oven",
        "overall", "owner", "oxygen", "oyster", "package", "page", "pain", "painting", "pair",
        "panda", "panel", "panic", "pants", "paper", "parade", "parent", "park", "parrot",
        "part", "partner", "party", "passage", "passenger", "passion", "passport", "past",
        "patent", "path", "patient", "pattern", "pause", "payment", "peace", "peach", "peanut",
        "pear", "peasant", "penalty", "pencil", "penguin", "people", "pepper", "percent",
        "perception", "performance", "perfume", "period", "permission", "person", "pet",
        "pharmacy", "philosophy", "phone", "photo", "phrase", "physical", "physics", "piano",
        "pickle", "picture", "piece", "pig", "pilot", "pineapple", "pink", "pioneer", "pipe",
        "pistol", "pizza", "place", "plan", "planet", "plant", "plastic", "plate", "play",
        "pleasant", "pleasure", "plenty", "pocket", "poem", "poet", "point", "poison", "police",
        "policy", "polish", "politics", "pollution", "pool", "popular", "population", "port",
        "position", "positive", "possible", "post", "potato", "pottery", "poverty", "power",
        "practice", "praise", "prayer", "precious", "preference", "preparation", "presence",
        "present", "president", "pressure", "price", "pride", "primary", "principle", "print",
        "priority", "prison", "private", "prize", "problem", "procedure", "process", "produce",
        "product", "profession", "profile", "profit", "program", "project", "promise", "proof",
        "property", "proposal", "protection", "protein", "protest", "proud", "province", "psychology",
        "public", "publisher", "pumpkin", "purchase", "purpose", "puzzle", "quality", "quantity",
        "quarter", "queen", "question", "quick", "quiet", "quilt", "quit", "quiz", "quote",
        "rabbit", "raccoon", "race", "radio", "railroad", "rainbow", "raisin", "rally", "range",
        "rat", "rate", "rather", "raven", "raw", "razor", "reach", "react", "read", "ready",
        "real", "reason", "rebel", "rebuild", "recall", "receive", "recipe", "record", "recycle",
        "red", "reduce", "reflect", "reform", "refuse", "region", "regret", "regular", "reject",
        "relate", "relax", "release", "relief", "rely", "remain", "remember", "remind", "remove",
        "render", "renew", "rent", "reopen", "repair", "repeat", "replace", "report", "require",
        "rescue", "research", "resemble", "resist", "resource", "response", "result", "retire",
        "retreat", "return", "reunion", "reveal", "review", "reward", "rhino", "rhythm", "rib",
        "ribbon", "rice", "rich", "ride", "ridge", "rifle", "right", "rigid", "ring", "riot",
        "ripple", "risk", "ritual", "rival", "river", "road", "roast", "robot", "robust", "rocket",
        "romance", "roof", "rookie", "room", "rose", "rotate", "rough", "round", "route", "royal",
        "rubber", "rude", "rug", "rule", "run", "runway", "rural", "sad", "saddle", "sadness",
        "safe", "sail", "salad", "salmon", "salt", "salute", "same", "sample", "sand", "satisfy",
        "satoshi", "sauce", "sausage", "save", "say", "scale", "scan", "scare", "scatter", "scene",
        "scheme", "school", "science", "scissors", "scorpion", "scout", "scrap", "screen", "script",
        "scrub", "sea", "search", "season", "seat", "second", "secret", "section", "security",
        "seed", "seek", "segment", "select", "sell", "seminar", "senior", "sense", "sentence",
        "series", "service", "session", "settle", "setup", "seven", "shadow", "shaft", "shallow",
        "share", "shed", "shell", "sheriff", "shield", "shift", "shine", "ship", "shiver", "shock",
        "shoe", "shoot", "shop", "short", "shoulder", "shove", "shrimp", "shrug", "shuffle",
        "shy", "sibling", "sick", "side", "siege", "sight", "sign", "silent", "silk", "silly",
        "silver", "similar", "simple", "since", "sing", "siren", "sister", "situate", "six",
        "size", "skate", "sketch", "ski", "skill", "skin", "skirt", "skull", "slab", "slam",
        "sleep", "slender", "slice", "slide", "slight", "slim", "slogan", "slot", "slow", "slush",
        "small", "smart", "smile", "smoke", "smooth", "snack", "snake", "snap", "sniff", "snow",
        "soap", "soccer", "social", "sock", "soda", "soft", "solar", "soldier", "solid", "solution",
        "solve", "someone", "song", "soon", "sorry", "sort", "soul", "sound", "soup", "source",
        "south", "space", "spare", "spatial", "spawn", "speak", "special", "speed", "spell",
        "spend", "sphere", "spice", "spider", "spike", "spin", "spirit", "split", "spoil",
        "sponsor", "spoon", "sport", "spot", "spray", "spread", "spring", "spy", "square", "squeeze",
        "squirrel", "stable", "stadium", "staff", "stage", "stairs", "stamp", "stand", "start",
        "state", "stay", "steak", "steel", "stem", "step", "stereo", "stick", "still", "sting",
        "stock", "stomach", "stone", "stool", "story", "stove", "strategy", "street", "strike",
        "strong", "struggle", "student", "stuff", "stumble", "style", "subject", "submit", "subway",
        "success", "such", "sudden", "suffer", "sugar", "suggest", "suit", "summer", "sun",
        "sunny", "sunset", "super", "supply", "supreme", "sure", "surface", "surge", "surprise",
        "surround", "survey", "suspect", "sustain", "swallow", "swamp", "swap", "swarm", "swear",
        "sweet", "swift", "swim", "swing", "switch", "sword", "symbol", "symptom", "syrup",
        "system", "table", "tackle", "tag", "tail", "talent", "talk", "tank", "tape", "target",
        "task", "taste", "tattoo", "taxi", "teach", "team", "tell", "ten", "tenant", "tennis",
        "tent", "term", "test", "text", "thank", "that", "theme", "then", "theory", "there",
        "they", "thing", "this", "thought", "three", "thrive", "throw", "thumb", "thunder",
        "ticket", "tide", "tiger", "tilt", "timber", "time", "tiny", "tip", "tired", "tissue",
        "title", "toast", "tobacco", "today", "toddler", "toe", "together", "toilet", "token",
        "tomato", "tomorrow", "tone", "tongue", "tonight", "tool", "tooth", "top", "topic",
        "topple", "torch", "tornado", "tortoise", "toss", "total", "tourist", "toward", "tower",
        "town", "toy", "track", "trade", "traffic", "tragic", "train", "transfer", "trap",
        "trash", "travel", "tray", "treat", "tree", "trend", "trial", "tribe", "trick", "trigger",
        "trim", "trip", "trophy", "trouble", "truck", "true", "truly", "trumpet", "trust", "truth",
        "try", "tube", "tuition", "tumble", "tuna", "tunnel", "turkey", "turn", "turtle", "twelve",
        "twenty", "twice", "twin", "twist", "two", "type", "typical", "ugly", "umbrella", "unable",
        "unaware", "uncle", "uncover", "under", "undo", "unfair", "unfold", "unhappy", "uniform",
        "unique", "unit", "universe", "unknown", "unlock", "until", "unusual", "unveil", "update",
        "upgrade", "uphold", "upon", "upper", "upset", "urban", "urge", "usage", "use", "used",
        "useful", "useless", "usual", "utility", "vacant", "vacuum", "vague", "valid", "valley",
        "valve", "van", "vanish", "vapor", "various", "vast", "vault", "vehicle", "velvet", "vendor",
        "venture", "venue", "verb", "verify", "version", "very", "vessel", "veteran", "viable",
        "vibrant", "vicious", "victory", "video", "view", "village", "vintage", "violin", "virtual",
        "virus", "visa", "visit", "visual", "vital", "vivid", "vocal", "voice", "void", "volcano",
        "volume", "vote", "voyage", "wage", "wagon", "wait", "walk", "wall", "walnut", "want",
        "warfare", "warm", "warrior", "wash", "wasp", "waste", "water", "wave", "way", "wealth",
        "weapon", "wear", "weasel", "weather", "web", "wedding", "weekend", "weird", "welcome",
        "welfare", "well", "west", "wet", "whale", "what", "wheat", "wheel", "when", "where",
        "whip", "whisper", "wide", "width", "wife", "wild", "will", "win", "window", "wine",
        "wing", "wink", "winner", "winter", "wire", "wisdom", "wise", "wish", "witness", "wolf",
        "woman", "wonder", "wood", "wool", "word", "work", "world", "worry", "worth", "wrap",
        "wreck", "wrestle", "wrist", "write", "wrong", "yard", "year", "yellow", "you", "young",
        "youth", "zebra", "zero", "zone", "zoo"
    }
    
    for _, word in pairs(commonWords) do
        if not table.find(WordList, word) then
            table.insert(WordList, word)
        end
    end
    
    updateWordListDisplay()
    Rayfield:Notify({
        Title = "📚 Dictionary Loaded",
        Content = "Loaded " .. #commonWords .. " English words",
        Duration = 3,
        Image = 4483362458,
    })
end

function updateWordListDisplay()
    WordListLabel:Set("Total Words: " .. #WordList)
    
    local recentWords = ""
    local count = 0
    for i = 1, math.min(10, #WordList) do
        recentWords = recentWords .. WordList[i] .. ", "
        count = count + 1
    end
    
    if count > 0 then
        recentWords = string.sub(recentWords, 1, -3)
        WordListPreview:Set({
            Title = "Recent Words (" .. count .. " shown)",
            Content = recentWords
        })
    else
        WordListPreview:Set({
            Title = "Recent Words",
            Content = "No words added yet"
        })
    end
end

function updateHistoryDisplay()
    local historyText = ""
    for i = 1, math.min(10, #WordHistory) do
        local entry = WordHistory[i]
        historyText = historyText .. entry.time .. " - " .. entry.word .. " → " .. entry.lastLetter .. "\n"
    end
    
    if historyText == "" then
        historyText = "No history yet"
    end
    
    HistoryDisplay:Set({
        Title = "Recent Words (" .. #WordHistory .. " entries)",
        Content = historyText
    })
end

function exportWordList()
    local wordsText = table.concat(WordList, "\n")
    setclipboard(wordsText)
    Rayfield:Notify({
        Title = "📋 Copied to Clipboard",
        Content = "Exported " .. #WordList .. " words",
        Duration = 3,
        Image = 4483362458,
    })
end

function importWordList()
    -- This would normally import from clipboard or file
    Rayfield:Notify({
        Title = "⚠️ Feature Coming Soon",
        Content = "Import feature will be added soon",
        Duration = 3,
        Image = 4483362458,
    })
end

function generateAISuggestion(letter)
    if not letter or letter == "" then
        Rayfield:Notify({
            Title = "⚠️ No Letter",
            Content = "Please provide a starting letter",
            Duration = 2,
            Image = 4483362458,
        })
        return
    end
    
    AIResponseLabel:Set("🤖 AI: Generating word for letter '" .. letter .. "'...")
    
    local suggestion = generateWordWithAI(letter)
    if suggestion then
        SuggestedWordLabel:Set("💡 Suggested Word: " .. suggestion)
        AIResponseLabel:Set("🤖 AI: Generated '" .. suggestion .. "'")
        
        Rayfield:Notify({
            Title = "✨ AI Suggestion",
            Content = "Word: " .. suggestion,
            Duration = 3,
            Image = 4483362458,
        })
    else
        AIResponseLabel:Set("🤖 AI: Failed to generate word")
    end
end

-- Auto-detection loop
spawn(function()
    while wait(1) do
        if AutoAnswer or AutoType then
            detectCurrentWord()
        end
    end
end)

-- Initialize
Rayfield:Notify({
    Title = "🚀 Last Letter Word Helper V4 Loaded",
    Content = "AI-Powered Assistant Ready!\nMade by Assistant",
    Duration = 5,
    Image = 4483362458,
})

-- Load configuration
wait(1)
Rayfield:LoadConfiguration()

-- Initial update
updateWordListDisplay()
updateHistoryDisplay()